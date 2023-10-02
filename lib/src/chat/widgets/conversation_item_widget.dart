import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gem_dubi/common/constants.dart';
import 'package:gem_dubi/common/utils/timeago.dart';
import 'package:gem_dubi/src/chat/controllers/message_controller.dart';
import 'package:gem_dubi/src/chat/conversation_screen.dart';
import 'package:gem_dubi/src/chat/entities/conversation_model.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/guest_user.dart';

class ChatItemWidget extends ConsumerStatefulWidget {
  const ChatItemWidget({
    super.key,
    required this.item,
  });

  final ConversationModel item;

  @override
  ConsumerState<ChatItemWidget> createState() => _ChatItemWidgetState();
}

class _ChatItemWidgetState extends ConsumerState<ChatItemWidget> {
  bool _isInit = true;

  String currentUserId = '';
  String receiverUserId = '';
  String nameOfUser = '';
  ChatUser? imageOfUser;
  StreamSubscription? _onlineStreamSubcription;

  bool _isReceiverOnline = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _onlineStreamSubcription?.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      print('INBOX :: LISTITEM :: didChangeDependencies()');
      GuestUser user = ref.read(loginProviderRef).user;
      final receiver = widget.item.participantList.firstWhereOrNull((element) => element.id != user.id);
      currentUserId = user.id;
      receiverUserId = receiver?.id ?? '';
      nameOfUser = receiver?.displayName ?? '';
      print('INBOX :: LISTITEM :: RECEIVER USER FETCHED didChangeDependencies()');
      try {
        _onlineStreamSubcription = FirebaseFirestore.instance.collection('users-availability').doc(receiverUserId).collection('availability').snapshots().listen((event) async {
          if (event.docChanges.isNotEmpty) {
            final statusDoc = await FirebaseFirestore.instance.collection('users-availability').doc(receiverUserId).collection('availability').doc('status').get();
            if (statusDoc.exists) {
              final data = statusDoc.data();
              print('#### USER Status : ${data?['status']}');
              if (data != null) {
                // ignore: avoid_bool_literals_in_conditional_expressions
                _isReceiverOnline = data['status'];
              }
              if (mounted) setState(() {});
            }
          }
        });
      } catch (err) {
        print(err);
      }
      if (mounted) setState(() {});
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print('INBOX :: LISTITEM :: BUILD() called');
    print(widget.item.conversationType.name);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ConversationScreen(
              conversationId: widget.item.id,
              conversationModel: widget.item,
            );
          },
        ));
      },
      child: Slidable(
        key: ValueKey(widget.item.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          //dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              onPressed: (context) async {
                final response = await showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: widget.item.conversationType == ConversationType.private ? const Text('Delete Chat') : const Text('Delete Group'),
                      content: Text('Do you really want to delete this ${widget.item.conversationType == ConversationType.private ? 'chat' : 'group'} ?'),
                      backgroundColor: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );
                if (response != null) {
                  if (widget.item.conversationType == ConversationType.private) {
                    ref.read(messageControllerRef).deletePrivateConversations(
                          conversationModel: widget.item,
                          deleted: widget.item.deleted!,
                          deletedTimestamp: widget.item.deletedTimeStamp!,
                          ref: ref,
                        );
                  } else if (widget.item.conversationType == ConversationType.group && currentUserId == kAdminId) {
                    ref.read(messageControllerRef).deleteGroupConversations(conversationId: widget.item.id);
                  } else {
                    ref.read(messageControllerRef).deletePrivateConversations(
                          conversationModel: widget.item,
                          deleted: widget.item.deleted!,
                          deletedTimestamp: widget.item.deletedTimeStamp!,
                          ref: ref,
                        );
                  }
                }
              },
              backgroundColor: theme.colorScheme.background,
              padding: const EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(15),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              // label: 'Delete',
            ),
            const SizedBox(width: 10),
          ],
        ),
        // component is not dragged.
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.item.conversationType == ConversationType.private
                      ? Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: widget.item.participantList.firstWhereOrNull((element) => element.id == receiverUserId)?.image ?? '',
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                                errorWidget: (context, url, error) {
                                  return Container(
                                    decoration: const BoxDecoration(color: Colors.blue),
                                    alignment: Alignment.center,
                                    child: Text(
                                      nameOfUser.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (_isReceiverOnline)
                              const Positioned(
                                right: -3,
                                bottom: -1,
                                child: CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Color.fromRGBO(28, 255, 23, 1),
                                ),
                              ),
                          ],
                        )
                      : Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.people,
                            color: Colors.white,
                          ),
                        ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.item.conversationType == ConversationType.private ? nameOfUser : widget.item.title ?? '',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.item.updatedAt != null ? TimeAgoFormat.timeAgo(widget.item.updatedAt!) : '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.item.lastMessageSender!.id != currentUserId ? widget.item.lastMessageSender!.displayName : 'You'} : ${widget.item.lastMessageSummary}' ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
