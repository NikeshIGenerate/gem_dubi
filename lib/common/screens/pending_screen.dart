import 'package:flutter/material.dart';
import 'package:gem_dubi/common/screens/home_screen_layout.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/widgets/loading_widget.dart';
import 'package:gem_dubi/const/resource.dart';
import 'package:gem_dubi/src/login/controller/login_controller.dart';
import 'package:gem_dubi/src/login/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart';

class PendingScreen extends StatefulHookConsumerWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends ConsumerState<PendingScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _isLoading
        ? const LoadingWidget(
            color: Colors.white,
          )
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const SizedBox(
                  height: 150,
                  child: RiveAnimation.asset(R.ASSETS_RIVE_SEARCH_RIV),
                ),
                Text(
                  'We are evaluating your profile',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'In order to make our community holds up a standard, we don\'t allow any profiles to get in',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  'Please be patient',
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      User? user = await ref.read(loginProviderRef).init();
                      if (user != null && user.status == UserState.approved && user.tagTypeId != null) {
                        router.replaceAllWith(const HomeScreenLayout());
                      }
                    },
                    label: const Text(
                      'Refresh',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                  ),
                ),
                const SizedBox(height: 10),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      ref.read(loginProviderRef).logout();
                    },
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          );
  }
}
