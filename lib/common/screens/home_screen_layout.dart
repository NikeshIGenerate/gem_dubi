import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gem_dubi/common/screens/pending_screen.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/widgets/custom_nav_bar.dart';
import 'package:gem_dubi/common/wrappers/debouncer.dart';
import 'package:gem_dubi/src/chat/controllers/message_controller.dart';
import 'package:gem_dubi/src/events/controllers/events_controller.dart';
import 'package:gem_dubi/src/events/screens/bookings_screen.dart';
import 'package:gem_dubi/src/events/screens/home_screen.dart';
import 'package:gem_dubi/src/events/screens/map_screen.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/guest_user.dart';
import 'package:gem_dubi/src/login/screens/profile_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreenLayout extends StatefulHookConsumerWidget {
  const HomeScreenLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenLayout> createState() => _HomeScreenLayoutState();
}

class _HomeScreenLayoutState extends ConsumerState<HomeScreenLayout> with WidgetsBindingObserver {
  bool _isInit = true;

  final debouncer = Debouncer(milliseconds: 5000);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      GuestUser? user = ref.read(loginProviderRef).userNullable;
      if (user != null && (user.status == UserState.pending || user.tagTypeId == null)) {
        print('debouncer called');
        debouncer.run(() async {
          await login();
        });
      }
      _isInit = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        final user = ref.read(loginProviderRef).user;
        if (user.status == UserState.approved) {
          ref.read(messageControllerRef).updateAvailabilityStatus(user.id, true);
        }
        break;
      case AppLifecycleState.inactive:
        final user = ref.read(loginProviderRef).user;
        if (user.status == UserState.approved) {
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

  Future<void> login() async {
    GuestUser? user = await ref.read(loginProviderRef).init();
    if (user != null && user.status == UserState.approved && user.tagTypeId != null) {
      unawaited(ref.read(loginProviderRef).setDeviceToken(user));
      unawaited(subscribeGroupNotificationForUser(user));
      addNewUserToGroup(user);
      debouncer.dispose();
      router.replaceAllWith(const HomeScreenLayout());
    } else {
      debouncer.run(() async {
        await login();
      });
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
    if (groups.isEmpty) return;
    for (var element in groups) {
      bool isExists = element.participantsIds.any((ele) => ele == user.id);
      if (!isExists) {
        await ref.read(messageControllerRef).addNewUserToExistingGroup(element.id, user);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    debouncer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: 3);
    final userController = ref.watch(loginProviderRef);
    useListenable(controller);

    if (userController.userNullable?.isPending ?? false) {
      return const PendingScreen();
    }

    if (userController.userNullable?.tagTypeId == null) {
      return const PendingScreen();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: TabBarView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          EventsHomeScreen(),
          BookingsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        icons: [
          NavItem(icon: Icons.home),
          NavItem(icon: const IconDataSolid(0xf145)),
          // NavItem(icon: FontAwesomeIcons.locationDot),
          NavItem(icon: FontAwesomeIcons.solidUser),
          NavItem(icon: FontAwesomeIcons.map),
        ],
        index: controller.index,
        onChange: (index) {
          if(index == 3) {
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              enableDrag: false,
              isScrollControlled: true,
              builder: (context) => const MapScreen(),
            );
            return;
          }
          controller.index = index;
          if (index == 0) {
            print('Event Called');
            final user = ref.read(loginProviderRef).user;
            ref.watch(eventControllerRef).init(user);
          }
        },
      ),
    );
  }
}
