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
    apiKey: 'AIzaSyA-djbp7L2pRPrHMq4t5rXsbrPJz_am9Hg',
    appId: '1:46759671488:web:6f91647e0d77ac81219f25',
    messagingSenderId: '46759671488',
    projectId: 'crudoperation-7302a',
    authDomain: 'crudoperation-7302a.firebaseapp.com',
    storageBucket: 'crudoperation-7302a.appspot.com',
    measurementId: 'G-2CVVKJY4RB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAe6OOkCoWZgp1e9vpNkHR1E6txMZQUChc',
    appId: '1:46759671488:android:06f23e3b83f0bd5e219f25',
    messagingSenderId: '46759671488',
    projectId: 'crudoperation-7302a',
    storageBucket: 'crudoperation-7302a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADZHdbXjxNoeBjXKdyTKRqOMXRg3XmTdo',
    appId: '1:46759671488:ios:ffb5f6de80c10a8b219f25',
    messagingSenderId: '46759671488',
    projectId: 'crudoperation-7302a',
    storageBucket: 'crudoperation-7302a.appspot.com',
    iosBundleId: 'com.example.crudoperation',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyADZHdbXjxNoeBjXKdyTKRqOMXRg3XmTdo',
    appId: '1:46759671488:ios:ffb5f6de80c10a8b219f25',
    messagingSenderId: '46759671488',
    projectId: 'crudoperation-7302a',
    storageBucket: 'crudoperation-7302a.appspot.com',
    iosBundleId: 'com.example.crudoperation',
  );
}