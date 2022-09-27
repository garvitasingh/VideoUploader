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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBiolGFnHhA9hXfDYLOa5E8nZ-1vPhvriI',
    appId: '1:4313963483:web:e2ac2bbd6db15b425565fe',
    messagingSenderId: '4313963483',
    projectId: 'video-player-2d29e',
    authDomain: 'video-player-2d29e.firebaseapp.com',
    storageBucket: 'video-player-2d29e.appspot.com',
    measurementId: 'G-BGVRVX8CZ6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbuy8CyhXlvRmeofXxpXZL6CfWjJZJ47Y',
    appId: '1:4313963483:android:402625ec61677fcc5565fe',
    messagingSenderId: '4313963483',
    projectId: 'video-player-2d29e',
    storageBucket: 'video-player-2d29e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfZpKmZ4ZsGwwBmnziNMDHG_d_EXQPiaQ',
    appId: '1:4313963483:ios:78fa77c0927c7e7a5565fe',
    messagingSenderId: '4313963483',
    projectId: 'video-player-2d29e',
    storageBucket: 'video-player-2d29e.appspot.com',
    iosClientId: '4313963483-f0sn96vmp6keuvmgmflog9nqoss91hko.apps.googleusercontent.com',
    iosBundleId: 'com.example.phoneAuthVideo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCfZpKmZ4ZsGwwBmnziNMDHG_d_EXQPiaQ',
    appId: '1:4313963483:ios:78fa77c0927c7e7a5565fe',
    messagingSenderId: '4313963483',
    projectId: 'video-player-2d29e',
    storageBucket: 'video-player-2d29e.appspot.com',
    iosClientId: '4313963483-f0sn96vmp6keuvmgmflog9nqoss91hko.apps.googleusercontent.com',
    iosBundleId: 'com.example.phoneAuthVideo',
  );
}