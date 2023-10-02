import 'dart:developer';
import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/src/chat/controllers/conversation_controller.dart';
import 'package:gem_dubi/src/chat/controllers/message_controller.dart';
import 'package:gem_dubi/src/chat/entities/conversation_model.dart';
import 'package:gem_dubi/src/chat/entities/message_model.dart';
import 'package:gem_dubi/src/chat/entities/participant_model.dart';
import 'package:gem_dubi/src/chat/widgets/media_container_widget.dart';
import 'package:gem_dubi/src/chat/widgets/receiver_profile_chat_item_widget.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final ConversationModel conversationModel;

  const ConversationScreen({
    super.key,
    required this.conversationId,
    required this.conversationModel,
  });

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  bool _isInit = true;
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();

  final messageListProvider = StateNotifierProvider.autoDispose.family<ConversationNotifier, List<MessageModel>, String>((ref, conversationId) {
    final messageStream = ref.watch(messageListenerProvider(conversationId));
    return ConversationNotifier(messageStream.asData?.value ?? []);
  });

  final _messageTextEditingController = TextEditingController();
  List<ChatMessage> messages = [];
  ChatUser? user;
  ChatMessage? currentReply;

  ParticipantModel? userEmbedModel;

  final _messageFocusNode = FocusNode();

  bool isKeyboardOpen = false;

  ConversationNotifier? conversationNotifier;

  @override
  void initState() {
    super.initState();
    _messageTextEditingController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final userProfile = ref.read(loginProviderRef).user;
      final names = userProfile.displayName.split(' ');
      user = ChatUser(
        id: userProfile.id,
        firstName: names[0],
        lastName: names.length > 1 ? names[1] : '',
        profileImage: userProfile.image,
      );
      userEmbedModel = userProfile.toParticipant();
      _isInit = false;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageListState = messageListProvider(widget.conversationId);
    final messageList = ref.watch(messageListState);
    final messageListNotifier = ref.read(messageListState.notifier);
    conversationNotifier = messageListNotifier;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom > 0 ? MediaQuery.of(context).viewInsets.bottom - 50 : MediaQuery.of(context).viewInsets.bottom;
    setMessagesList(messageList);
    log('messageList.length = ${messageList.length}');
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? const SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Please Wait...'),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
                    child: DashChat(
                      messageListOptions: MessageListOptions(
                        dateSeparatorBuilder: (date) {
                          if (date.day == DateTime.now().day && date.month == DateTime.now().month && date.month == DateTime.now().month) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                'Today',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                _formatDateSeparator(date),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            );
                          }
                        },
                      ),
                      currentUser: user!,
                      onSend: (ChatMessage m) async {
                        final replyId = currentReply?.id;
                        setState(() {
                          currentReply = null;
                        });
                        await messageListNotifier.sendMessage(
                          conversationId: widget.conversationId,
                          message: m.text,
                          replyId: replyId,
                          ref: ref,
                        );
                      },
                      inputOptions: InputOptions(
                        focusNode: _messageFocusNode,
                        textController: _messageTextEditingController,
                        alwaysShowSend: true,
                        sendButtonBuilder: (send) {
                          return IconButton(
                            onPressed: send,
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          );
                        },
                        showTraillingBeforeSend: true,
                        inputDecoration: InputDecoration(
                          isDense: true,
                          hintText: 'Message',
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).brightness == Brightness.light ? const Color.fromRGBO(238, 241, 249, 1) : Colors.grey[900],
                          contentPadding: const EdgeInsets.only(left: 18, top: 15, bottom: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        currentReply: _currentReplyWidget(context),
                        trailing: _messageTextEditingController.text.isEmpty
                            ? [
                                InkWell(
                                  onTap: () async {
                                    _messageFocusNode.unfocus();
                                    await showGalleryPick(messageListNotifier);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                    child: Icon(
                                      Icons.attach_file,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ]
                            : null,
                      ),
                      messageOptions: MessageOptions(
                        onLongPressMessage: (message) async {
                          final response = await showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                contentPadding: const EdgeInsets.all(5.0),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (message.text != '')
                                      ListTile(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(text: message.text));
                                          Navigator.of(ctx).pop();
                                        },
                                        leading: const Icon(Icons.copy),
                                        title: const Text('Copy Text'),
                                      ),
                                    if (message.text != '') const Divider(),
                                    // ListTile(
                                    //   onTap: () {
                                    //     currentReply = message;
                                    //     Navigator.of(ctx).pop(true);
                                    //   },
                                    //   leading: const Icon(Icons.reply),
                                    //   title: const Text('Reply'),
                                    // ),
                                    // const Divider(),
                                    ListTile(
                                      onTap: () {
                                        ref.read(messageControllerRef).deleteMessage(
                                              conversationId: widget.conversationId,
                                              messageId: message.id,
                                              ref: ref,
                                            );
                                        Navigator.of(ctx).pop();
                                      },
                                      leading: const Icon(Icons.delete),
                                      title: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          if (response != null) {
                            FocusScope.of(context).requestFocus(_messageFocusNode);
                          }
                        },
                        showOtherUsersAvatar: false,
                        showOtherUsersName: false,
                        messageMediaBuilder: (message, previousMessage, nextMessage) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: MediaContainerWidget(
                              key: ValueKey(message.id),
                              currentUser: user!,
                              message: message,
                              isOwnMessage: message.user.id == user!.id,
                            ),
                          );
                        },
                        top: (message, previousMessage, nextMessage) {
                          if (message.user.id == user!.id) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 2),
                              child: Text(
                                DateFormat('HH:mm').format(message.createdAt),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }
                          return ReceiverChatProfileWidget(message: message);
                        },
                        messageDecorationBuilder: (message, previousMessage, nextMessage) {
                          return message.user.id == user!.id
                              ? const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(4),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                )
                              : const BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                );
                        },
                        messagePadding: const EdgeInsets.all(12),
                      ),
                      messages: messages,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void setMessagesList(List<MessageModel> data) {
    messages.clear();
    for (final e in data) {
      log(e.id);
      final names = e.sender.displayName.split(' ');
      if (e.deleted?[user!.id] == null || e.deleted?[user!.id] == false) {
        final chatMessage = ChatMessage(
          id: e.id,
          user: ChatUser(
            id: e.sender.id,
            firstName: names[0],
            lastName: names.length > 1 ? names[1] : '',
            profileImage: e.sender.image,
          ),
          medias: e.mediaList.isNotEmpty
              ? e.mediaList.map((e) {
                  return ChatMedia(
                    url: e.url,
                    isUploading: !e.url.startsWith('http'),
                    type: e.mediaType == MessageMediaType.image
                        ? MediaType.image
                        : e.mediaType == MessageMediaType.video
                            ? MediaType.video
                            : MediaType.file,
                    fileName: e.fileName,
                    customProperties: e.mediaType == MessageMediaType.image || e.mediaType == MessageMediaType.video
                        ? {
                            'photoHeight': e.height?.toDouble(),
                            'photoWidth': e.width?.toDouble(),
                            'photoHash': e.hash,
                            'photoSize': e.size,
                          }
                        : {
                            'size': e.size,
                          },
                  );
                }).toList()
              : null,
          text: e.message,
          status: MessageStatus.read,
          createdAt: e.updatedAt ?? DateTime.now(),
        );
        messages.add(chatMessage);
      }
    }
    setState(() {});
  }

  ChatMessage getReplyMessage(MessageModel e) {
    // if(widget.conversationModel.conversationType == ConversationType.group && user!.id != kAdminId && e.sender.id != user!.id) {
    //   return null;
    // }
    final names = e.sender.displayName.split(' ');
    final chatMessage = ChatMessage(
      id: e.id,
      user: ChatUser(
        id: e.sender.id,
        firstName: names[0],
        lastName: names.length > 1 ? names[1] : '',
        profileImage: e.sender.image,
      ),
      medias: e.mediaList.isNotEmpty
          ? e.mediaList.map((e) {
              return ChatMedia(
                url: e.url,
                isUploading: !e.url.startsWith('http'),
                type: e.mediaType == MessageMediaType.image
                    ? MediaType.image
                    : e.mediaType == MessageMediaType.video
                        ? MediaType.video
                        : MediaType.file,
                fileName: e.fileName,
                customProperties: e.mediaType == MessageMediaType.image || e.mediaType == MessageMediaType.video
                    ? {
                        'photoHeight': e.height?.toDouble(),
                        'photoWidth': e.width?.toDouble(),
                        'photoHash': e.hash,
                        'photoSize': e.size,
                      }
                    : {
                        'size': e.size,
                      },
              );
            }).toList()
          : null,
      text: e.message,
      status: MessageStatus.read,
      createdAt: e.updatedAt ?? DateTime.now(),
    );
    return chatMessage;
  }

  String _formatDateSeparator(DateTime date) {
    final today = DateTime.now();

    if (date.year != today.year) {
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } else if (date.month != today.month || _getWeekOfYear(date) != _getWeekOfYear(today)) {
      return DateFormat('dd MMM HH:mm').format(date);
    } else if (date.day != today.day) {
      return DateFormat('E HH:mm').format(date);
    }
    return DateFormat('HH:mm').format(date);
  }

  int _getWeekOfYear(DateTime date) {
    final dayOfYear = int.parse(DateFormat('D').format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  Widget? _currentReplyWidget(BuildContext context) {
    return currentReply != null
        ? IntrinsicHeight(
            child: Row(
              children: [
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
                      color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade200 : Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 10, right: 6, top: 6, bottom: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                currentReply!.user.id != user!.id ? '${currentReply!.user.firstName} ${currentReply!.user.lastName}' : 'You',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentReply = null;
                                });
                              },
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        if (currentReply!.medias == null && currentReply!.text != '')
                          Text(
                            currentReply!.text,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 4,
                          )
                        else if (currentReply!.medias != null && currentReply!.medias!.any((element) => element.type == MediaType.image))
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
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              )
                            ],
                          )
                        else if (currentReply!.medias != null && currentReply!.medias!.any((element) => element.type == MediaType.video))
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
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              )
                            ],
                          )
                        else if (currentReply!.medias != null && currentReply!.medias!.any((element) => element.type == MediaType.file))
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
                                  fontSize: 16,
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
          )
        : null;
  }

  Future<void> showGalleryPick(ConversationNotifier conversationNotifier) async {
    final theme = Theme.of(context);

    final response = await showModalBottomSheet<String?>(
      context: context,
      builder: (ctx) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () async {
                    Navigator.of(ctx).pop('image');
                  },
                  // leading: const Icon(Icons.photo),
                  leading: const Icon(Icons.photo),
                  title: Text('Image', style: theme.textTheme.labelLarge),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.of(ctx).pop('video');
                  },
                  // leading: const Icon(Icons.video_camera_back),
                  leading: const Icon(Icons.video_camera_back),
                  title: Text('Video', style: theme.textTheme.labelLarge),
                ),
                ListTile(
                  onTap: () async {
                    Navigator.of(ctx).pop('audio');
                  },
                  // leading: const Icon(Icons.video_camera_back),
                  leading: const Icon(Icons.headphones),
                  title: Text('Audio', style: theme.textTheme.labelLarge),
                ),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        );
      },
    );
    if (response == 'image') {
      await imagePickFunc(ImageSource.gallery, conversationNotifier);
    } else if (response == 'video') {
      await videoPickFunc(ImageSource.gallery, conversationNotifier);
    } else if (response == 'audio') {
      await audioPickFunc(conversationNotifier);
    }
  }

  Future<void> imagePickFunc(ImageSource source, ConversationNotifier conversationNotifier) async {
    var list = <File>[];
    try {
      if (source == ImageSource.gallery) {
        final imagesList = await _picker.pickMultiImage();
        if (imagesList.isNotEmpty) {
          if (!mounted) return;
          list = imagesList.map((e) => File(e.path)).toList();
        }
      }
      if (list.isNotEmpty) {
        log('image selected : ${list.length}');

        await conversationNotifier.sendPhotoMediaMessage(
          conversationId: widget.conversationId,
          message: _messageTextEditingController.text,
          photosList: list,
          ref: ref,
          replyId: currentReply?.id,
        );
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> videoPickFunc(ImageSource source, ConversationNotifier conversationNotifier) async {
    File? file;
    try {
      if (source == ImageSource.gallery) {
        final video = await _picker.pickVideo(source: ImageSource.gallery);
        if (video != null) {
          if (!mounted) return;
          file = File(video.path);
        }
      }
      if (file != null) {
        log('video selected');
        await conversationNotifier.sendVideoMediaMessage(
          conversationId: widget.conversationId,
          message: _messageTextEditingController.text,
          video: file,
          ref: ref,
          replyId: currentReply?.id,
        );
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> audioPickFunc(ConversationNotifier conversationNotifier) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      if (!mounted) return;
      final file = File(result.files.single.path!);
      log('audio selected');
      await conversationNotifier.sendAudioMediaMessage(
        conversationId: widget.conversationId,
        message: _messageTextEditingController.text,
        audio: file,
        ref: ref,
        replyId: currentReply?.id,
      );
    }
  }
}
