import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gem_dubi/src/chat/controllers/cloud_photo_repository.dart';
import 'package:gem_dubi/src/chat/entities/blurhash_params.dart';
import 'package:gem_dubi/src/chat/entities/message_model.dart';
import 'package:image/image.dart' as imagepkg;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CloudPhotosRepositoryImpl extends CloudPhotosRepository {
  /// Default cache duration for media
  /// 604800 seconds = 7 days
  /// 604800 = 7 days x 24 hours x 60 minutes x 60 seconds
  ///
  ///

  CloudPhotosRepositoryImpl._();

  static CloudPhotosRepositoryImpl? _instance;

  factory CloudPhotosRepositoryImpl.instance() {
    _instance ??= CloudPhotosRepositoryImpl._();

    return _instance!;
  }

  int get defaultCacheDurationInSeconds => 7 * 24 * 60 * 60;

  /// Returns a string containing the blurhash of the image provided.
  /// Should be run on an isolate using `compute()`.
  /// More info: https://api.flutter.dev/flutter/foundation/compute-constant.html
  static Future<String> processImageObject(BlurHashParams params) async {
    final stopwatch = Stopwatch()..start();
    final fileBytes = await params.imageFile.readAsBytes();
    log('read file into bytes array. elapsed: ${stopwatch.elapsed.inMilliseconds}');
    final img = await Future.delayed(const Duration(milliseconds: 500), () {
      return imagepkg.decodeImage(fileBytes);
    });
    log('decode image from bytes array. elapsed: ${stopwatch.elapsed.inMilliseconds}');

    var optimizedWidth = params.width > params.height ? (params.width * 0.5).toInt().clamp(100, params.width) : null;
    var optimizedHeight = params.height > params.width ? (params.height * 0.5).toInt().clamp(100, params.height) : null;

    if (optimizedWidth == null && optimizedHeight == null) {
      optimizedWidth = (params.width * 0.5).toInt().clamp(100, params.width);
      optimizedHeight = (params.height * 0.5).toInt().clamp(100, params.height);
    }

    final rimg = imagepkg.copyResize(
      img!,
      width: optimizedWidth,
      height: optimizedHeight,
    );

    log('resize image to 10% size. elapsed: ${stopwatch.elapsed.inMilliseconds}');

    final blurHash = await Future.microtask(() {
      log('_computeHash.BlurHash.encode');
      return BlurHash.encode(rimg, numCompX: 3, numCompY: 2);
      // return BlurHash.encode(rimg);
    });
    log('compute blurhash on resized image. elapsed: ${stopwatch.elapsed.inMilliseconds}');
    stopwatch.stop();
    log('_computeHash.blurHash.hash = ${blurHash.hash}');
    return blurHash.hash;
  }

  @override
  Future<void> deleteMedia(List<MessageMediaModel> mediaToDelete) {
    return Future.wait(mediaToDelete.map((e) => FirebaseStorage.instance.ref().child(e.fileName).delete()));
  }

  Future<String> _computeHash(BlurHashParams params) async {
    return compute(processImageObject, params);
  }

  Future<Reference> _saveToCloud(File imageFile, String filename) async {
    final ref = FirebaseStorage.instance.ref().child(filename);
    log('filename = $filename');
    log('ref.storage.bucket = ${ref.storage.bucket}');
    await ref.putFile(imageFile, SettableMetadata(cacheControl: 'max-age=$defaultCacheDurationInSeconds'));
    return ref;
  }

  Future<void> _downloadFromCloud({
    required String url,
    required String filename,
    required File original,
    required FullMetadata metaData,
  }) async {
    final appDocDirectory = Platform.isIOS ? await getApplicationSupportDirectory() : await getExternalStorageDirectory();

    final mediaFolderDirectory = Directory('${appDocDirectory!.path}/media');
    log('mediaFolderDirectory.path = ${mediaFolderDirectory.path}');

    final isDirectoryExists = mediaFolderDirectory.existsSync();
    log('isDirectoryExists = $isDirectoryExists');

    if (!isDirectoryExists) {
      await mediaFolderDirectory.create();
    }

    final file = File('${mediaFolderDirectory.path}/$filename.${metaData.contentType?.split('/')[1]}');
    log(file.path);

    await original.copy(file.path);
  }

  Future<Size> _getImageSize(File imageFile) async {
    final completer = Completer<ui.Image>();

    Image.file(imageFile).image.resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((ImageInfo image, bool _) {
        completer.complete(image.image);
      }),
    );

    final info = await completer.future;
    final width = info.width;
    final height = info.height;

    return Size(width.toDouble(), height.toDouble());
  }

  @override
  Future<MessageMediaModel> saveImage(File image, [String? filename]) async {
    final imageFile = File(image.path);

    final cloudFilename = '${filename != null ? '$filename-' : ''}${UniqueKey().hashCode}';
    log('image.originalPath = ${image.path}');

    int imgWidth;
    int imgHeight;

    final size = await _getImageSize(imageFile);
    imgWidth = size.width.toInt();
    imgHeight = size.height.toInt();

    final results = await Future.wait([
      _computeHash(
        BlurHashParams(
          imageFile: imageFile,
          width: imgWidth,
          height: imgHeight,
        ),
      ),
      _saveToCloud(imageFile, cloudFilename),
    ]);

    final hash = results[0] as String;
    final cloudFileRef = results[1] as Reference;

    final url = await cloudFileRef.getDownloadURL();
    final metadata = await cloudFileRef.getMetadata();
    await _downloadFromCloud(url: url, filename: cloudFilename, original: imageFile, metaData: metadata);
    log('[cloudPhotosRepository.saveImage] hash = $hash');
    log('[cloudPhotosRepository.saveImage] filename = $cloudFilename');
    log('[cloudPhotosRepository.saveImage] fullPath = ${cloudFileRef.fullPath}');
    log('[cloudPhotosRepository.saveImage] url = $url');
    log('[cloudPhotosRepository.saveImage] imgWidth = $imgWidth');
    log('[cloudPhotosRepository.saveImage] imgHeight = $imgHeight');
    log('[cloudPhotosRepository.saveImage] size = ${metadata.size}');

    return MessageMediaModel(
      fileName: cloudFilename,
      url: url,
      hash: hash,
      width: imgWidth,
      height: imgHeight,
      size: metadata.size,
      mediaType: MessageMediaType.image,
    );
  }

  @override
  Future<MessageMediaModel> saveVideo(File video, [String? filename]) async {
    final videoFile = File(video.path);

    final thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: videoFile.path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      quality: 100,
    );

    int height;
    int width;

    final size = await _getImageSize(File(thumbnailFile!));
    width = size.width.toInt();
    height = size.height.toInt();

    final cloudFilename = '${filename != null ? '$filename-' : ''}${UniqueKey().hashCode}';
    log('video.originalPath = ${video.path}');

    final results = await Future.wait([
      _computeHash(
        BlurHashParams(
          imageFile: File(thumbnailFile),
          width: width,
          height: height,
        ),
      ),
      _saveToCloud(videoFile, cloudFilename),
    ]);

    final hash = results[0] as String;
    final cloudFileRef = results[1] as Reference;

    final url = await cloudFileRef.getDownloadURL();
    final metadata = await cloudFileRef.getMetadata();
    await _downloadFromCloud(url: url, filename: cloudFilename, original: videoFile, metaData: metadata);

    log('[cloudPhotosRepository.saveVideo] filename = $cloudFilename');
    log('[cloudPhotosRepository.saveVideo] fullPath = ${cloudFileRef.fullPath}');
    log('[cloudPhotosRepository.saveVideo] url = $url');
    log('[cloudPhotosRepository.saveVideo] hash = $hash');
    log('[cloudPhotosRepository.saveVideo] height = $height');
    log('[cloudPhotosRepository.saveVideo] width = $width');
    log('[cloudPhotosRepository.saveVideo] size = ${metadata.size}');

    return MessageMediaModel(
      fileName: cloudFilename,
      url: url,
      hash: hash,
      width: height,
      height: width,
      size: metadata.size,
      mediaType: MessageMediaType.video,
    );
  }

  @override
  Future<MessageMediaModel> saveAudio(File audio, [String? filename]) async {
    final audioFile = File(audio.path);
    final cloudFilename = filename!;
    log('audio.originalPath = ${audio.path}');

    final cloudFileRef = await _saveToCloud(audioFile, cloudFilename);

    final url = await cloudFileRef.getDownloadURL();
    final metadata = await cloudFileRef.getMetadata();
    await _downloadFromCloud(url: url, filename: cloudFilename, original: audioFile, metaData: metadata);

    log('[cloudPhotosRepository.saveAudio] filename = $cloudFilename');
    log('[cloudPhotosRepository.saveAudio] fullPath = ${cloudFileRef.fullPath}');
    log('[cloudPhotosRepository.saveAudio] url = $url');
    log('[cloudPhotosRepository.saveAudio] size = ${metadata.size}');

    return MessageMediaModel(
      fileName: cloudFilename,
      url: url,
      height: 0,
      width: 0,
      hash: '',
      size: metadata.size,
      mediaType: MessageMediaType.audio,
    );
  }
}
