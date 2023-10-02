import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/src/chat/controllers/cloud_photo_repository.dart';
import 'package:gem_dubi/src/chat/controllers/download_file_notifier.dart';
import 'package:gem_dubi/src/chat/entities/media_download_model.dart';
import 'package:gem_dubi/src/chat/widgets/circular_progress_indicator_with_cancel.dart';
import 'package:gem_dubi/src/chat/widgets/video_player_widget.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:octo_image/octo_image.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class NetworkMediaWidget extends ConsumerStatefulWidget {
  const NetworkMediaWidget({
    required this.media,
    this.height,
    this.width,
    super.key,
  });

  final ChatMedia media;
  final double? height;
  final double? width;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends ConsumerState<NetworkMediaWidget> {
  bool _isInit = true;
  final downloadFileProvider = StateNotifierProvider<DownloadFileNotifier, MediaDownModel?>((ref) {
    return DownloadFileNotifier();
  });

  File? _file;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    log('initState');
    _isFileExists();
  }

  Future<void> _isFileExists() async {
    final storage = FirebaseStorage.instanceFor(bucket: CloudPhotosRepository.chatsBucket, app: Firebase.app());
    final appDocDirectory = Platform.isIOS ? await getApplicationSupportDirectory() : await getExternalStorageDirectory();
    final mediaFolderDirectory = Directory('${appDocDirectory!.path}/media');
    final storageRef = storage.refFromURL(widget.media.url);
    final metaData = await storageRef.getMetadata();
    final file = File('${mediaFolderDirectory.path}/${widget.media.fileName}.${metaData.contentType?.split('/')[1]}');
    log('file.path = ${file.path}');

    if (file.existsSync()) {
      _file = file;
    }

    _isInit = false;

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Widget loading = Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.all(10),
      child: const CircularProgressIndicator(),
    );
    final mediaDownloadModel = ref.watch(downloadFileProvider);
    if (_isDownloading &&
        mediaDownloadModel != null &&
        mediaDownloadModel.fileName == widget.media.fileName &&
        mediaDownloadModel.taskState == TaskState.success) {
      _file = mediaDownloadModel.file;
      _isDownloading = false;
    }
    switch (widget.media.type) {
      case MediaType.video:
        return GestureDetector(
          key: widget.key,
          onTap: !_isDownloading
              ? () async {
                  if (_file == null) {
                    setState(() {
                      _isDownloading = true;
                    });
                    await ref.read(downloadFileProvider.notifier).downloadFile(media: widget.media);
                    final result = await ImageGallerySaver.saveFile(_file!.path);
                    log('Video File Saved : $result');
                  } else {
                    await OpenFilex.open(_file!.path);
                  }
                }
              : null,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              SizedBox(
                height: (widget.media.customProperties!['photoHeight']! as num).toDouble(),
                width: (widget.media.customProperties!['photoWidth']! as num).toDouble(),
                child: _isDownloading || _file == null
                    ? Image(
                        image: BlurHashImage(widget.media.customProperties!['photoHash'] as String),
                        fit: BoxFit.cover,
                      )
                    : VideoPlayerWidget(
                        file: _file!,
                        hash: widget.media.customProperties!['photoHash'] as String,
                      ),
              ),
              if (!_isInit && !_isDownloading && _file == null)
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(3),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              if (!_isInit && _file == null)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: _file == null &&
                          _isDownloading &&
                          mediaDownloadModel!.fileName == widget.media.fileName &&
                          mediaDownloadModel.downloadProgress > 0
                      ? CircularProgressIndicatorWithCancel(
                          onTap: () {
                            ref.read(downloadFileProvider.notifier).cancelDownload();
                          },
                          progress: mediaDownloadModel.downloadProgress,
                          scale: 0.75,
                          color: mediaDownloadModel.taskState == TaskState.running ? Colors.green : Colors.white,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.download_rounded,
                                size: 15,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                getFileSizeString(
                                  bytes: (widget.media.customProperties!['photoSize']! as num).toInt(),
                                ),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              if (widget.media.isUploading) loading
            ],
          ),
        );
      case MediaType.image:
        return GestureDetector(
          key: widget.key,
          onTap: !_isDownloading
              ? () async {
                  if (_file == null) {
                    setState(() {
                      _isDownloading = true;
                    });
                    await ref.read(downloadFileProvider.notifier).downloadFile(media: widget.media);
                  } else {
                    await OpenFilex.open(_file!.path);
                  }
                }
              : null,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              SizedBox(
                height: (widget.media.customProperties!['photoHeight']! as num).toDouble(),
                width: (widget.media.customProperties!['photoWidth']! as num).toDouble(),
                child: _isDownloading || _file == null
                    ? Image(
                        image: BlurHashImage(widget.media.customProperties!['photoHash'] as String),
                        fit: BoxFit.cover,
                      )
                    : OctoImage(
                        image: FileImage(_file!),
                        placeholderBuilder:
                            OctoPlaceholder.blurHash(widget.media.customProperties!['photoHash'] as String),
                        errorBuilder: OctoError.icon(color: Theme.of(context).colorScheme.error),
                        fit: BoxFit.cover,
                        height: (widget.media.customProperties!['photoHeight']! as num).toDouble(),
                        width: (widget.media.customProperties!['photoWidth']! as num).toDouble(),
                        memCacheWidth: (widget.media.customProperties!['photoWidth']! as num).toInt(),
                        memCacheHeight: (widget.media.customProperties!['photoHeight']! as num).toInt(),
                      ),
              ),
              if (!_isInit && _file == null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: _isDownloading &&
                          mediaDownloadModel!.fileName == widget.media.fileName &&
                          mediaDownloadModel.downloadProgress > 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Transform.scale(
                              scale: 0.5,
                              child: CircularProgressIndicator(
                                value: mediaDownloadModel.downloadProgress,
                                color: mediaDownloadModel.taskState == TaskState.running
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${(mediaDownloadModel.downloadProgress * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.download_rounded,
                              size: 26,
                              color: Colors.white,
                            ),
                            Text(
                              getFileSizeString(
                                bytes: (widget.media.customProperties!['photoSize']! as num).toInt(),
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              if (widget.media.isUploading) loading
            ],
          ),
        );
      case MediaType.file:
        return GestureDetector(
          key: widget.key,
          onTap: !_isDownloading
              ? () {
                  if (_file == null) {
                    setState(() {
                      _isDownloading = true;
                    });
                    ref.read(downloadFileProvider.notifier).downloadFile(media: widget.media);
                  } else {
                    OpenFilex.open(_file!.path);
                  }
                }
              : null,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: !widget.media.isUploading
                      ? const Icon(
                          Icons.headphones,
                          size: 36,
                          color: Colors.white,
                        )
                      : loading,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.media.fileName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        getFileSizeString(bytes: (widget.media.customProperties?['size'] ?? 0) as int),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_file == null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _file == null &&
                            _isDownloading &&
                            mediaDownloadModel!.fileName == widget.media.fileName &&
                            mediaDownloadModel.downloadProgress > 0
                        ? CircularProgressIndicatorWithCancel(
                            onTap: () {
                              ref.read(downloadFileProvider.notifier).cancelDownload();
                            },
                            progress: mediaDownloadModel.downloadProgress,
                            scale: 0.75,
                            margin: EdgeInsets.zero,
                            color: mediaDownloadModel.taskState == TaskState.running
                                ? Colors.green
                                : Colors.white,
                          )
                        : Container(
                            height: 30,
                            width: 30,
                            decoration: const BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.download,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                  )
                else
                  const Icon(
                    Icons.play_arrow,
                    size: 30,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        );
      // ignore: no_default_cases
      default:
        return Container();
      // return Container();
    }
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ['bytes', 'KB', 'MB', 'GB', 'TB'];

    if (bytes == 0) return '0${suffixes[0]}';

    final i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
