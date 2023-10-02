import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/src/chat/widgets/file_media_widget.dart';
import 'package:gem_dubi/src/chat/widgets/network_media_widget.dart';

class MediaContainerWidget extends ConsumerStatefulWidget {
  const MediaContainerWidget({
    required this.currentUser,
    required this.message,
    required this.isOwnMessage,
    super.key,
  });

  final ChatUser currentUser;

  /// Message that contains the media to show
  final ChatMessage message;

  /// If the message is from the current user
  final bool isOwnMessage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MediaContainerState();
}

class _MediaContainerState extends ConsumerState<MediaContainerWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.message.medias != null && widget.message.medias!.isNotEmpty) {
      final media = widget.message.medias!;
      return Column(
        children: [
          if (widget.message.replyTo != null)
            Container(
              padding: const EdgeInsets.only(right: 5),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                            ),
                          ),
                          width: 7,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade200 : Theme.of(context).colorScheme.background,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                              ),
                            ),
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.message.replyTo!.user.id != widget.currentUser.id ? '${widget.message.replyTo!.user.firstName} ${widget.message.replyTo!.user.lastName}' : 'You',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                if (widget.message.replyTo!.medias == null && widget.message.replyTo!.text != '')
                                  Text(
                                    widget.message.replyTo!.text,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                else if (widget.message.replyTo!.medias != null && widget.message.replyTo!.medias!.any((element) => element.type == MediaType.image))
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
                                else if (widget.message.replyTo!.medias != null && widget.message.replyTo!.medias!.any((element) => element.type == MediaType.video))
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
                                else if (widget.message.replyTo!.medias != null && widget.message.replyTo!.medias!.any((element) => element.type == MediaType.file))
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
                ],
              ),
            ),
          Wrap(
            alignment: widget.isOwnMessage ? WrapAlignment.end : WrapAlignment.start,
            children: media.map((ChatMedia m) {
              final gallerySize = (MediaQuery.of(context).size.width * 0.7) / 2 - 5;
              final isImage = m.type == MediaType.image;

              return Container(
                color: Colors.transparent,
                margin: widget.message.replyTo == null ? const EdgeInsets.only(top: 5, right: 5) : const EdgeInsets.only(right: 5),
                width: media.length > 1 && isImage ? gallerySize : null,
                height: media.length > 1 && isImage ? gallerySize : null,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                child: ClipRRect(
                  borderRadius: widget.message.replyTo == null
                      ? BorderRadius.circular(8)
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      m.isUploading ? Colors.white54 : Colors.white.withOpacity(0.1), // Because transparent is causing an issue on flutter web
                      BlendMode.srcATop,
                    ),
                    child: m.isUploading
                        ? FileMediaWidget(
                            media: m,
                            height: media.length > 1 ? gallerySize : null,
                            width: media.length > 1 ? gallerySize : null,
                          )
                        : NetworkMediaWidget(
                            key: ValueKey(m.fileName),
                            media: m,
                            height: media.length > 1 ? gallerySize : null,
                            width: media.length > 1 ? gallerySize : null,
                          ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }
    return const SizedBox();
  }
}
