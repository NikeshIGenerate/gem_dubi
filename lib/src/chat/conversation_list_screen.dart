import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/constants.dart';
import 'package:gem_dubi/common/widgets/loading_widget.dart';
import 'package:gem_dubi/src/chat/controllers/conversation_controller.dart';
import 'package:gem_dubi/src/chat/controllers/message_controller.dart';
import 'package:gem_dubi/src/chat/create_group_screen.dart';
import 'package:gem_dubi/src/chat/entities/conversation_model.dart';
import 'package:gem_dubi/src/chat/users_list_screen.dart';
import 'package:gem_dubi/src/chat/widgets/conversation_item_widget.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/guest_user.dart';

class ConversationListScreen extends ConsumerStatefulWidget {
  const ConversationListScreen({super.key});

  @override
  ConsumerState<ConversationListScreen> createState() => _ConversationListScreenState();
}

class _ConversationListScreenState extends ConsumerState<ConversationListScreen> with WidgetsBindingObserver {
  bool _isInit = true;
  List<ConversationModel> conversationList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final user = ref.read(loginProviderRef).user;
      if (user.email == kAdminEmail) {
        unawaited(ref.read(messageControllerRef).fetchCategories());
        unawaited(subscribeGroupNotificationForAdmin(user));
      }
      _isInit = false;
    }
  }

  Future<void> subscribeGroupNotificationForAdmin(GuestUser user) async {
    final groups = await ref.read(messageControllerRef).getGroupConversationByUserId(user.id);
    if (groups.isNotEmpty) {
      for (var element in groups) {
        unawaited(FirebaseMessaging.instance.subscribeToTopic('${element.id}-admin'));
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        final user = ref.read(loginProviderRef).user;
        if (user.email == kAdminEmail) {
          ref.read(messageControllerRef).updateAvailabilityStatus(user.id, true);
        }
        break;
      case AppLifecycleState.inactive:
        final user = ref.read(loginProviderRef).user;
        if (user.email == kAdminEmail) {
          ref.read(messageControllerRef).updateAvailabilityStatus(user.id, false);
        }
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRef = ref.read(loginProviderRef);
    final messageRef = ref.read(messageControllerRef);
    final conversationProviderState = ref.watch(conversationListenerProvider);
    conversationList = conversationProviderState.asData?.value ?? [];
    print(conversationList);
    return Scaffold(
      appBar: AppBar(
        title: kAdminEmail == userRef.user.email ? const Text('My Chats') : const Text('Chat Support'),
        actions: [
          if (kAdminEmail == userRef.user.email)
            PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return const CreateGroupUserListScreen();
                        },
                      ));
                    },
                    child: const Text('New Group'),
                  ),
                  PopupMenuItem(
                    onTap: () async {
                      await ref.read(loginProviderRef).logout();
                    },
                    child: const Text('Logout'),
                  ),
                ];
              },
            ),
        ],
      ),
      body: conversationProviderState.maybeWhen(
        loading: () => const LoadingWidget(
          color: Colors.white60,
        ),
        data: (data) {
          return data.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  itemBuilder: (context, index) {
                    return ChatItemWidget(
                      key: ValueKey(conversationList[index].id),
                      item: conversationList[index],
                    );
                  },
                  separatorBuilder: (context, index) => const Column(
                    children: [
                      SizedBox(height: 8),
                      Divider(
                        thickness: 0.2,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                  itemCount: conversationList.length,
                )
              : const Center(
                  child: Text('No Chats'),
                );
        },
        error: (error, stackTrace) {
          print(error);
          return const Center(
            child: Text('No Chats'),
          );
        },
        orElse: () => const Center(
          child: Text('No Chats'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const UsersListScreen();
              },
            ),
          );
        },
        child: const Icon(
          Icons.chat,
          color: Colors.black,
        ),
      ),
    );
  }
}
