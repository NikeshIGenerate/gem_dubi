// import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../src/login/guest_user.dart';

class RemoteNotificationWrapper {
  static final instance = RemoteNotificationWrapper();

  Future<void> init() async {
    // await OneSignal.shared.setAppId('a8db0d2b-c77e-4cfc-94e8-737288b0ff3a');
    // OneSignal.shared.promptUserForPushNotificationPermission();
  }

  setUser(
    GuestUser? user, {
    String? language,
  }) {
    if (user == null) return;

    // OneSignal.shared.setExternalUserId(user.id);
    // if (language != null) OneSignal.shared.setLanguage(language);
    // OneSignal.shared.setEmail(email: user.email);
    // if (user.phone != null) {
    //   OneSignal.shared.setSMSNumber(smsNumber: user.phone!);
    // }
  }
}
