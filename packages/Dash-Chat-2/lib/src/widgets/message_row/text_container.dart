part of dash_chat_2;

/// @nodoc
class TextContainer extends StatelessWidget {
  const TextContainer({
    required this.message,
    required this.currentUser,
    this.messageOptions = const MessageOptions(),
    this.previousMessage,
    this.nextMessage,
    this.isOwnMessage = false,
    this.isPreviousSameAuthor = false,
    this.isNextSameAuthor = false,
    this.isAfterDateSeparator = false,
    this.isBeforeDateSeparator = false,
    this.messageTextBuilder,
    Key? key,
  }) : super(key: key);

  /// Options to customize the behaviour and design of the messages
  final MessageOptions messageOptions;

  /// Current user of the chat
  final ChatUser currentUser;

  /// Message that contains the text to show
  final ChatMessage message;

  /// Previous message in the list
  final ChatMessage? previousMessage;

  /// Next message in the list
  final ChatMessage? nextMessage;

  /// If the message is from the current user
  final bool isOwnMessage;

  /// If the previous message is from the same author as the current one
  final bool isPreviousSameAuthor;

  /// If the next message is from the same author as the current one
  final bool isNextSameAuthor;

  /// If the message is preceded by a date separator
  final bool isAfterDateSeparator;

  /// If the message is before by a date separator
  final bool isBeforeDateSeparator;

  /// We could acces that from messageOptions but we want to reuse this widget
  /// for media and be able to override the text builder
  final Widget Function(ChatMessage, ChatMessage?, ChatMessage?)? messageTextBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: messageOptions.messageDecorationBuilder != null
          ? messageOptions.messageDecorationBuilder!(message, previousMessage, nextMessage)
          : defaultMessageDecoration(
              color: isOwnMessage
                  ? (messageOptions.currentUserContainerColor ?? Theme.of(context).primaryColor)
                  : (messageOptions.containerColor ?? Colors.grey[100])!,
              borderTopLeft: isPreviousSameAuthor && !isOwnMessage && !isAfterDateSeparator ? 0.0 : 18.0,
              borderTopRight: isPreviousSameAuthor && isOwnMessage && !isAfterDateSeparator ? 0.0 : 18.0,
              borderBottomLeft: !isOwnMessage && !isBeforeDateSeparator && isNextSameAuthor ? 0.0 : 18.0,
              borderBottomRight: isOwnMessage && !isBeforeDateSeparator && isNextSameAuthor ? 0.0 : 18.0,
            ),
      padding: messageOptions.messagePadding ?? const EdgeInsets.all(11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.replyTo != null)
            Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      if (!isOwnMessage)
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              topLeft: Radius.circular(8),
                            ),
                          ),
                          width: 7,
                        ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.grey.shade200
                                : Theme.of(context).colorScheme.background,
                            borderRadius: !isOwnMessage
                                ? const BorderRadius.only(
                                    bottomRight: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  )
                                : BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.only(left: 10, right: 6, top: 6, bottom: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.replyTo!.user.id != currentUser.id
                                    ? '${message.replyTo!.user.firstName} ${message.replyTo!.user.lastName}'
                                    : 'You',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              if (message.replyTo!.medias == null && message.replyTo!.text != '')
                                Text(
                                  message.replyTo!.text,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 4,
                                )
                              else if (message.replyTo!.medias != null &&
                                  message.replyTo!.medias!.any((element) => element.type == MediaType.image))
                                Row(
                                  children: [
                                    Icon(
                                      Icons.photo,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Photo',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    )
                                  ],
                                )
                              else if (message.replyTo!.medias != null &&
                                  message.replyTo!.medias!.any((element) => element.type == MediaType.video))
                                Row(
                                  children: [
                                    Icon(
                                      Icons.video_camera_back,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Video',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    )
                                  ],
                                )
                              else if (message.replyTo!.medias != null &&
                                  message.replyTo!.medias!.any((element) => element.type == MediaType.file))
                                Row(
                                  children: [
                                    Icon(
                                      Icons.photo,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Audio',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                      ),
                                    )
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          if (messageTextBuilder != null)
            messageTextBuilder!(message, previousMessage, nextMessage)
          else
            Padding(
              padding: message.replyTo != null ? const EdgeInsets.only(left: 5) : EdgeInsets.zero,
              child: DefaultMessageText(
                message: message,
                isOwnMessage: isOwnMessage,
                messageOptions: messageOptions,
              ),
            ),
        ],
      ),
    );
  }
}
