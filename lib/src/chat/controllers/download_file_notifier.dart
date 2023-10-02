import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/src/chat/controllers/cloud_photo_repository.dart';
import 'package:gem_dubi/src/chat/entities/media_download_model.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFileNotifier extends StateNotifier<MediaDownModel> {
  DownloadFileNotifier()
      : super(
          MediaDownModel(
            fileName: '',
            taskState: TaskState.success,
            downloadProgress: 0,
            file: File(''),
          ),
        );
  StreamSubscription<TaskSnapshot>? _streamSubscription;

  Future<void> downloadFile({required ChatMedia media}) async {
    final storage = FirebaseStorage.instanceFor(bucket: CloudPhotosRepository.chatsBucket, app: Firebase.app());

    final appDocDirectory = Platform.isIOS ? await getApplicationSupportDirectory() : await getExternalStorageDirectory();

    final mediaFolderDirectory = Directory('${appDocDirectory!.path}/media');
    log('mediaFolderDirectory.path = ${mediaFolderDirectory.path}');

    final isDirectoryExists = mediaFolderDirectory.existsSync();
    log('isDirectoryExists = $isDirectoryExists');

    if (!isDirectoryExists) {
      await mediaFolderDirectory.create();
    }

    final storageRef = storage.refFromURL(media.url);
    final metaData = await storageRef.getMetadata();

    final file = File('${mediaFolderDirectory.path}/${media.fileName}.${metaData.contentType?.split('/')[1]}');
    log('file.path = ${file.path}');

    final task = storageRef.writeToFile(file);

    _streamSubscription = task.snapshotEvents.listen((event) {
      final progress = event.bytesTransferred / event.totalBytes;

      log('progress = $progress');
      log('event.bytesTransferred = ${event.bytesTransferred}');
      log('event.totalBytes = ${event.totalBytes}');

      state = MediaDownModel(
        fileName: media.fileName,
        taskState: event.state,
        downloadProgress: progress,
        file: file,
      );
    });

    await task.whenComplete(() async {
      if (metaData.contentType?.split('/')[0] == 'image') {
        final result = await ImageGallerySaver.saveImage(file.readAsBytesSync());
        log('Image File Saved : $result');
      } else if (metaData.contentType?.split('/')[0] == 'video' && (metaData.contentType?.split('/')[1] != 'mpeg')) {
        final result = await ImageGallerySaver.saveFile(file.path);
        log('Video File Saved : $result');
      }
      await _streamSubscription?.cancel();
    });
  }

  void cancelDownload() {
    // Cancel the download by canceling the StreamSubscription
    _streamSubscription?.cancel();
  }
}
