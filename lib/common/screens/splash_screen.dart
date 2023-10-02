import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/constants.dart';
import 'package:gem_dubi/common/screens/home_screen_layout.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/widgets/loading_widget.dart';
import 'package:gem_dubi/common/widgets/logo.dart';
import 'package:gem_dubi/src/chat/controllers/message_controller.dart';
import 'package:gem_dubi/src/chat/conversation_list_screen.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/guest_user.dart';
import 'package:gem_dubi/src/login/screens/login_screen.dart';
import 'package:gem_dubi/src/on_boarding/on_boarding_repository.dart';
import 'package:gem_dubi/src/on_boarding/on_boarding_screens.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> initApp() async {
    // await Future.delayed(const Duration(milliseconds: 100));
    bool firstTime = await OnBoardingRepository.instance.firstLoad();

    // RemoteNotificationWrapper.instance.init().catchError((e) {});

    if (firstTime) {
      router.pushReplacement(const OnBoardingScreen());
    } else {
      GuestUser? user = await ref.read(loginProviderRef).init();
      print(user);
      if (user != null) {
        if (user.email == kAdminEmail) {
          unawaited(ref.read(loginProviderRef).setDeviceToken(user));
          router.replaceAllWith(const ConversationListScreen());
        } else {
          if (user.status == UserState.approved && user.tagTypeId != null) {
            unawaited(ref.read(loginProviderRef).setDeviceToken(user));
            unawaited(subscribeGroupNotificationForUser(user));
            await addNewUserToGroup(user);
          }
          router.replaceAllWith(const HomeScreenLayout());
        }
      } else {
        router.pushReplacement(const LoginScreen());
      }
      // router.pushReplacement(const LoginScreen());
    }
  }

  Future<void> subscribeGroupNotificationForUser(GuestUser user) async {
    final groups = await ref.read(messageControllerRef).getGroupConversationByUserId(user.id);
    if (groups.isNotEmpty) {
      for (var element in groups) {
        unawaited(FirebaseMessaging.instance.subscribeToTopic('${element.id}-user'));
      }
    }
  }

  Future<void> addNewUserToGroup(GuestUser user) async {
    final groups = await ref.read(messageControllerRef).getGroupConversationByGirlType(user.tagTypeId ?? 0);
    print('addNewUserToGroup ::: ${groups.length}');
    if (groups.isEmpty) return;
    for (var element in groups) {
      bool isExists = element.participantsIds.any((ele) => ele == user.id);
      print('addNewUserToGroup ::: ${isExists}');
      if (!isExists) {
        await ref.read(messageControllerRef).addNewUserToExistingGroup(element.id, user);
      }
    }
  }

  @override
  void initState() {
    initApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            transform: const GradientRotation(pi / 2),
            colors: [
              Colors.black.withOpacity(0),
              Colors.black,
            ],
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FractionallySizedBox(
              widthFactor: .3,
              child: Logo(),
            ),
            LoadingWidget(
              color: Colors.white60,
            ),
          ],
        ),
      ),
    );
  }
}
