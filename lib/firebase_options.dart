// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDxOYqVhBgkb0OulF_0UtdX8nvbnPNAWDE',
    appId: '1:517995116930:android:ef330d4bc1d2f71113379b',
    messagingSenderId: '517995116930',
    projectId: 'pharmavend',
    storageBucket: 'pharmavend.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfY6O6R0ec85ZUq2PsSxEWf6cKsqvSUm8',
    appId: '1:517995116930:ios:1f3c11e4eb15214d13379b',
    messagingSenderId: '517995116930',
    projectId: 'pharmavend',
    storageBucket: 'pharmavend.firebasestorage.app',
    androidClientId: '517995116930-02g8uuqghikvv4nmfmlovb1iut2bn84b.apps.googleusercontent.com',
    iosClientId: '517995116930-h765mr2ce7g4ebnn1bbs7ifb1f7vf83s.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication',
  );
}
