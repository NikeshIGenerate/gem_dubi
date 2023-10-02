import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart' as vp;

class FileMediaWidget extends ConsumerStatefulWidget {
  const FileMediaWidget({
    required this.media,
    this.height,
    this.width,
    super.key,
  });

  final ChatMedia media;
  final double? height;
  final double? width;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FileMediaWidgetState();
}

class _FileMediaWidgetState extends ConsumerState<FileMediaWidget> {
  @override
  Widget build(BuildContext context) {
    final Widget loading = Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.all(10),
      child: const CircularProgressIndicator(),
    );
    switch (widget.media.type) {
      case MediaType.video:
        return Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            VideoPlayer(
              url: widget.media.url,
              key: widget.key,
            ),
            if (widget.media.isUploading) loading,
          ],
        );
      case MediaType.image:
        return Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            Image(
              height: widget.height,
              width: widget.width,
              fit: BoxFit.cover,
              image: getImageProvider(widget.media.url),
            ),
            if (widget.media.isUploading) loading
          ],
        );
      case MediaType.file:
        return Container(
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
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.audio_file,
                  size: 36,
                  color: Colors.white,
                ),
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
                    const Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.media.isUploading)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    width: 15,
                    height: 15,
                    margin: const EdgeInsets.all(10),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      // ignore: no_default_cases
      default:
        return Container();
    }
  }

  ImageProvider getImageProvider(String url) {
    if (url.startsWith('http')) {
      return CachedNetworkImageProvider(url);
    } else if (url.startsWith('assets')) {
      return AssetImage(url);
    } else {
      return FileImage(File(url));
    }
  }
}

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    required this.url,
    this.aspectRatio = 1,
    this.canPlay = true,
    super.key,
  });

  /// Link of the video
  final String url;

  /// The Aspect Ratio of the Video. Important to get the correct size of the video
  final double aspectRatio;

  /// If the video can be played
  final bool canPlay;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late vp.VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.url.startsWith('http')) {
      _controller = vp.VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized,
          // even before the play button has been pressed.
          setState(() {});
        });
    } else if (widget.url.startsWith('assets')) {
      _controller = vp.VideoPlayerController.asset(widget.url)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized,
          // even before the play button has been pressed.
          setState(() {});
        });
    } else {
      _controller = vp.VideoPlayerController.file(File(widget.url))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized,
          // even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? ColoredBox(
            color: Colors.black,
            child: Stack(
              alignment: _controller.value.isPlaying ? AlignmentDirectional.bottomStart : AlignmentDirectional.center,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: vp.VideoPlayer(_controller),
                ),
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
              ],
            ),
          )
        : Container(color: Colors.black);
  }
}
