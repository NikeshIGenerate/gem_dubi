part of dash_chat_2;

/// @nodoc
class MediaContainer extends StatelessWidget {
  const MediaContainer({
    required this.message,
    required this.currentUser,
    required this.isOwnMessage,
    this.messageOptions = const MessageOptions(),
    Key? key,
  }) : super(key: key);

  final ChatUser currentUser;

  /// Message that contains the media to show
  final ChatMessage message;

  /// If the message is from the current user
  final bool isOwnMessage;

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;

  /// Get the right media widget according to its type
  Widget _getMedia(BuildContext context, ChatMedia media, double? height, double? width) {
    final Widget loading = Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.all(10),
      child: const CircularProgressIndicator(),
    );

    switch (media.type) {
      case MediaType.video:
        return Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            // VideoPlayer(
            //   chatMedia: media,
            //   height: MediaQuery.of(context).size.height * 0.5,
            //   width: MediaQuery.of(context).size.width * 0.6,
            //   key: key,
            // ),
            SizedBox(
              height: (media.customProperties!['photoHeight']! as num).toDouble(),
              width: (media.customProperties!['photoWidth']! as num).toDouble(),
              child: Image(
                image: BlurHashImage(media.customProperties!['photoHash'] as String),
                fit: BoxFit.cover,
              ),
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
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(left: 10, bottom: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.download_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      getFileSizeString(
                        bytes: (media.customProperties!['photoSize']! as num).toInt(),
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
            if (media.isUploading) loading
          ],
        );
      case MediaType.image:
        return Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            // Image(
            //   height: height,
            //   width: width,
            //   fit: BoxFit.cover,
            //   alignment: isOwnMessage ? Alignment.topRight : Alignment.topLeft,
            //   image: getImageProvider(media.url),
            // ),
            SizedBox(
              height: (media.customProperties!['photoHeight']! as num).toDouble(),
              width: (media.customProperties!['photoWidth']! as num).toDouble(),
              child: Image(
                image: BlurHashImage(media.customProperties!['photoHash'] as String),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.download_rounded,
                    size: 26,
                    color: Colors.white,
                  ),
                  Text(
                    getFileSizeString(
                      bytes: (media.customProperties!['photoSize']! as num).toInt(),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (media.isUploading) loading
          ],
        );
      default:
        return TextContainer(
          isOwnMessage: isOwnMessage,
          messageOptions: messageOptions,
          message: message,
          currentUser: currentUser,
          messageTextBuilder: (ChatMessage m, ChatMessage? p, ChatMessage? n) {
            return Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: !media.isUploading
                      ? Icon(
                          Icons.description,
                          size: 18,
                          color: isOwnMessage
                              ? (messageOptions.currentUserTextColor ?? Colors.white)
                              : (messageOptions.textColor ?? Colors.black),
                        )
                      : loading,
                ),
                Flexible(
                  child: Text(
                    media.fileName,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: isOwnMessage
                          ? (messageOptions.currentUserTextColor ?? Colors.white)
                          : (messageOptions.textColor ?? Colors.black),
                    ),
                  ),
                ),
              ],
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message.medias != null && message.medias!.isNotEmpty) {
      final List<ChatMedia> media = message.medias!;
      return Wrap(
        alignment: isOwnMessage ? WrapAlignment.end : WrapAlignment.start,
        children: media.map(
          (ChatMedia m) {
            final double gallerySize = (MediaQuery.of(context).size.width * 0.7) / 2 - 5;
            final bool isImage = m.type == MediaType.image;
            return Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(top: 5, right: 5),
              width: media.length > 1 && isImage ? gallerySize : null,
              height: media.length > 1 && isImage ? gallerySize : null,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: GestureDetector(
                onTap: messageOptions.onTapMedia != null ? () => messageOptions.onTapMedia!(m) : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      m.isUploading
                          ? Colors.white54
                          : Colors.white.withOpacity(
                              0.1,
                            ), // Because transparent is causing an issue on flutter web
                      BlendMode.srcATop,
                    ),
                    child: _getMedia(
                      context,
                      m,
                      media.length > 1 ? gallerySize : null,
                      media.length > 1 ? gallerySize : null,
                    ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      );
    }
    return const SizedBox();
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    final List<String> suffixes = <String>['bytes', 'KB', 'MB', 'GB', 'TB'];
    if (bytes == 0) {
      return '0${suffixes[0]}';
    }
    int i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }
}
