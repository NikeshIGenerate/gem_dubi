import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/screens/home_screen_layout.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/widgets/loading_widget.dart';
import 'package:gem_dubi/common/widgets/logo.dart';
import 'package:gem_dubi/common/wrappers/notification_wrapper.dart';
import 'package:gem_dubi/src/events/controllers/events_controller.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/screens/login_screen.dart';
import 'package:gem_dubi/src/login/user.dart';
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
      User? user = await ref.read(loginProviderRef).init();
      print(user);
      if(user != null) {
        router.replaceAllWith(const HomeScreenLayout());
      }
      else {
        router.pushReplacement(const LoginScreen());
      }
      // router.pushReplacement(const LoginScreen());
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
        child: Column(
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
