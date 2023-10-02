part of dash_chat_2;

/// @nodoc
class VideoPlayer extends StatefulWidget {
  const VideoPlayer({
    required this.chatMedia,
    required this.height,
    required this.width,
    this.aspectRatio = 1,
    this.canPlay = true,
    Key? key,
  }) : super(key: key);

  /// Link of the video
  final ChatMedia chatMedia;

  final double? height;

  final double? width;

  /// The Aspect Ratio of the Video. Important to get the correct size of the video
  final double aspectRatio;

  /// If the video can be played
  final bool canPlay;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool isPlay = false;
  late vp.VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = vp.VideoPlayerController.network(widget.chatMedia.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: widget.height,
      width: widget.width,
      child: Stack(
        alignment: _controller.value.isPlaying ? AlignmentDirectional.center : AlignmentDirectional.center,
        children: <Widget>[
          if (isPlay || _controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: vp.VideoPlayer(_controller),
            )
          else
            OctoImage(
              image: getImageProvider(widget.chatMedia.url),
              placeholderBuilder: (BuildContext ctx) => const Center(child: CircularProgressIndicator()),
              errorBuilder: OctoError.icon(color: Colors.red.shade700),
              fit: BoxFit.contain,
              height: widget.height,
              width: widget.width,
            ),
          IconButton(
            iconSize: _controller.value.isPlaying ? 24 : 60,
            onPressed: widget.canPlay
                ? () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        setState(() {
                          isPlay = false;
                        });
                      }
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                    });
                  }
                : null,
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              // size: 60,
            ),
          ),
        ],
      ),
    );
  }
}
