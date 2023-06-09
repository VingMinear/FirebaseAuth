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
    apiKey: 'AIzaSyBgHhY4QgG5SoEEaG2W_g-Z9-Ug1Y9_gvI',
    appId: '1:722001884220:web:419f70e5a6210e3c80bf39',
    messagingSenderId: '722001884220',
    projectId: 'fir-auth-1d214',
    authDomain: 'fir-auth-1d214.firebaseapp.com',
    storageBucket: 'fir-auth-1d214.appspot.com',
    measurementId: 'G-EX1DRMEQ7W',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1wo0O1H2_6VmXc-hQ2e628TeB0qVlRuU',
    appId: '1:722001884220:android:7b6b6435d640608980bf39',
    messagingSenderId: '722001884220',
    projectId: 'fir-auth-1d214',
    storageBucket: 'fir-auth-1d214.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyClYPKgh5J3LsGMUJc5P05-aggimyp1e1A',
    appId: '1:722001884220:ios:68373515f320907880bf39',
    messagingSenderId: '722001884220',
    projectId: 'fir-auth-1d214',
    storageBucket: 'fir-auth-1d214.appspot.com',
    iosClientId: '722001884220-pqk01uhlkuj3od04nt6je11ch18rejvi.apps.googleusercontent.com',
    iosBundleId: 'com.example.myApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyClYPKgh5J3LsGMUJc5P05-aggimyp1e1A',
    appId: '1:722001884220:ios:68373515f320907880bf39',
    messagingSenderId: '722001884220',
    projectId: 'fir-auth-1d214',
    storageBucket: 'fir-auth-1d214.appspot.com',
    iosClientId: '722001884220-pqk01uhlkuj3od04nt6je11ch18rejvi.apps.googleusercontent.com',
    iosBundleId: 'com.example.myApp',
  );
}
