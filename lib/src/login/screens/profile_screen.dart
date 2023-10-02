import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/constants.dart';
import 'package:gem_dubi/common/screens/terms_of_use_screen.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/widgets/avatar_image.dart';
import 'package:gem_dubi/src/chat/controllers/message_controller.dart';
import 'package:gem_dubi/src/chat/conversation_list_screen.dart';
import 'package:gem_dubi/src/chat/entities/participant_model.dart';
import 'package:gem_dubi/src/events/screens/bookings_screen.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/screens/edit_profile_screen.dart';
import 'package:gem_dubi/src/login/screens/login_screen.dart';
import 'package:gem_dubi/src/login/widget/list_item.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final loginProvider = ref.watch(loginProviderRef);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),

          Center(
            child: AvatarImage(
              image: loginProvider.userNullable?.image,
              padding: 7,
            ),
          ),
          Text(
            loginProvider.userNullable?.displayName ?? 'GEM Dubai',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),

          // Text(
          //   '@${loginProvider.user.instagramId??''}',
          //   style: theme.textTheme.labelLarge,
          //   textAlign: TextAlign.center,
          // ),
          const SizedBox(height: 10),
          loginProvider.isLoggedIn
              ? Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                    onPressed: () => router.push(
                      EditProfileScreen(
                        user: loginProvider.user,
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: ElevatedButton(
                    onPressed: () => router.push(const LoginScreen()),
                    child: const Text('LOGIN'),
                  ),
                ),
          const SizedBox(height: 30),
          const Divider(
            height: 50,
            indent: 20,
            endIndent: 10,
          ),
          ListItem(
            onTap: () => router.push(const BookingsScreen()),
            title: 'My Bookings',
            icon: Icons.local_activity,
          ),
          // ListItem(
          //   onTap: () => router.push(const BookingHistoryScreen(true)),
          //   title: 'History',
          //   icon: Icons.history,
          // ),
          const SizedBox(height: 7),
          ListItem(
            onTap: () async {
              final user = ref.read(loginProviderRef).user;
              final participants = [
                ParticipantModel(
                  id: user.id,
                  email: user.email,
                  displayName: user.displayName,
                  phone: user.phone,
                  image: user.image,
                  tagTypeId: user.tagTypeId,
                  tagTypeName: user.tagTypeName,
                ),
                ParticipantModel(
                  id: kAdminId,
                  email: kAdminEmail,
                  displayName: kAdminName,
                  phone: null,
                  image: null,
                  tagTypeId: null,
                  tagTypeName: null,
                )
              ];
              String convId = await ref.read(messageControllerRef).isConversationExists(participants);
              if (convId == '') convId = await ref.read(messageControllerRef).createPrivateConversation(participants, user);
              router.push(const ConversationListScreen());
            },
            title: 'Chat Support',
            icon: Icons.chat,
          ),
          const SizedBox(height: 7),
          ListItem(
            onTap: () {
              router.push(const TermsOfUseScreen());
            },
            title: 'Terms & Conditions',
            icon: Icons.data_usage,
          ),
          const SizedBox(height: 7),
          ListItem(
            onTap: () {
              launchUrl(
                Uri.parse('https://gemdubai.app/privacy-policy'),
              );
            },
            title: 'Privacy policy',
            icon: Icons.policy,
          ),
          const Divider(
            height: 40,
            indent: 20,
            endIndent: 10,
          ),
          if (loginProvider.isLoggedIn)
            ListItem(
              onTap: () async {
                final user = ref.read(loginProviderRef).user;
                final groups = await ref.read(messageControllerRef).getGroupConversationByUserId(user.id);
                if (groups.isNotEmpty) {
                  for (var element in groups) {
                    unawaited(FirebaseMessaging.instance.unsubscribeFromTopic('${element.id}-user'));
                  }
                }
                loginProvider.logout();
              },
              title: 'Logout',
              icon: Icons.logout,
            )
          else
            ListItem(
              onTap: () => router.push(const LoginScreen()),
              title: 'Login',
              icon: Icons.login,
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
