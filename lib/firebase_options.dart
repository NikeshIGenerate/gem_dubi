// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC4EZ5SczU_VHHaXqbjhoifNsgOLGzonjs',
    appId: '1:385097477534:android:72f02102c1ece49ad53a8f',
    messagingSenderId: '385097477534',
    projectId: 'gem-dubai',
    storageBucket: 'gem-dubai.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDM_1Ldt8ba-U2xsv76SiRAOlPYOk6rsA',
    appId: '1:385097477534:ios:8c2770e9aa969b5ad53a8f',
    messagingSenderId: '385097477534',
    projectId: 'gem-dubai',
    storageBucket: 'gem-dubai.appspot.com',
    androidClientId: '385097477534-75a9bf952rt7noshjiijofbp2a10lrer.apps.googleusercontent.com',
    iosClientId: '385097477534-am78r2rpiqpj32tp3rho96a9vv0bo137.apps.googleusercontent.com',
    iosBundleId: 'com.gem.mobile',
  );
}
