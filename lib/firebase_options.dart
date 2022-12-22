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
    apiKey: 'AIzaSyCcc6LO-hsaPO_JAEPa3Z7crJQk0U7UFOo',
    appId: '1:423743761053:web:ed0c01991fcee6e1f5c274',
    messagingSenderId: '423743761053',
    projectId: 'fasela-6c09f',
    authDomain: 'fasela-6c09f.firebaseapp.com',
    storageBucket: 'fasela-6c09f.appspot.com',
    measurementId: 'G-DZ5Z0TZYPR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDRP_UJsxXVxOLs0tVooS9yL0OSCnuVOg4',
    appId: '1:423743761053:android:934fecea313495aef5c274',
    messagingSenderId: '423743761053',
    projectId: 'fasela-6c09f',
    storageBucket: 'fasela-6c09f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCaIA6BORvR8I_FuoGUaNNKdwyOVZeSzaU',
    appId: '1:423743761053:ios:d03b9c1182b17b9af5c274',
    messagingSenderId: '423743761053',
    projectId: 'fasela-6c09f',
    storageBucket: 'fasela-6c09f.appspot.com',
    iosClientId: '423743761053-7dkjp7lt1d29hkv2e2il7kj0n12jsqj3.apps.googleusercontent.com',
    iosBundleId: 'com.example.faselaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCaIA6BORvR8I_FuoGUaNNKdwyOVZeSzaU',
    appId: '1:423743761053:ios:d03b9c1182b17b9af5c274',
    messagingSenderId: '423743761053',
    projectId: 'fasela-6c09f',
    storageBucket: 'fasela-6c09f.appspot.com',
    iosClientId: '423743761053-7dkjp7lt1d29hkv2e2il7kj0n12jsqj3.apps.googleusercontent.com',
    iosBundleId: 'com.example.faselaApp',
  );
}