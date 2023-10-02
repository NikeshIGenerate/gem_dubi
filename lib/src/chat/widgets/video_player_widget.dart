import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends ConsumerStatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.file,
    required this.hash,
  });

  final File file;
  final String hash;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  bool isPlay = false;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
      });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Stack(
        alignment: _controller.value.isPlaying ? AlignmentDirectional.center : AlignmentDirectional.center,
        children: <Widget>[
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          else
            Image(
              image: BlurHashImage(widget.hash),
              fit: BoxFit.cover,
            ),
          GestureDetector(
            // onTap: () {
            //   setState(() {
            //     if (_controller.value.isPlaying) {
            //       setState(() {
            //         isPlay = false;
            //       });
            //     }
            //     _controller.value.isPlaying ? _controller.pause() : _controller.play();
            //   });
            // },
            child: Container(
              decoration: !_controller.value.isPlaying
                  ? const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    )
                  : null,
              padding: const EdgeInsets.all(3),
              child: Icon(
                _controller.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: _controller.value.isPlaying ? 24 : 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
