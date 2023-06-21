import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gem_dubi/common/screens/pending_screen.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/widgets/custom_nav_bar.dart';
import 'package:gem_dubi/common/wrappers/debouncer.dart';
import 'package:gem_dubi/src/events/controllers/events_controller.dart';
import 'package:gem_dubi/src/events/screens/home_screen.dart';
import 'package:gem_dubi/src/events/screens/up_coming_ticket_screen.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/screens/profile_screen.dart';
import 'package:gem_dubi/src/login/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreenLayout extends StatefulHookConsumerWidget {
  const HomeScreenLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreenLayout> createState() => _HomeScreenLayoutState();
}

class _HomeScreenLayoutState extends ConsumerState<HomeScreenLayout> {

  bool _isInit = true;

  final debouncer = Debouncer(milliseconds: 5000);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      User? user = ref.read(loginProviderRef).userNullable;
      if(user != null && (user.status == UserState.pending || user.tagTypeId == null)) {
        print('debouncer called');
        debouncer.run(() async {
          await login();
        });
      }
      _isInit = false;
    }
  }

  Future<void> login() async {
    User? user = await ref.read(loginProviderRef).init();
    if (user != null && user.status == UserState.approved && user.tagTypeId != null) {
      debouncer.dispose();
      router.replaceAllWith(const HomeScreenLayout());
    }
    else {
      debouncer.run(() async {
        await login();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
          UpComingBookingsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        icons: [
          NavItem(icon: Icons.home),
          NavItem(icon: const IconDataSolid(0xf145)),
          // NavItem(icon: FontAwesomeIcons.locationDot),
          NavItem(icon: FontAwesomeIcons.solidUser),
        ],
        index: controller.index,
        onChange: (index) {
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
