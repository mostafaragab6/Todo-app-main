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
        return windows;
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
    apiKey: 'AIzaSyA5lxMx3mIEODxWl6pmfMHEQaBh1M3UQvE',
    appId: '1:694782907659:web:dbcd66ac5f6e35a05afe0e',
    messagingSenderId: '694782907659',
    projectId: 'todo-app-4b079',
    authDomain: 'todo-app-4b079.firebaseapp.com',
    storageBucket: 'todo-app-4b079.firebasestorage.app',
    measurementId: 'G-FNDF5WSXFK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7_dPZlxuOyatYgw-XpT_OplBVExa8mck',
    appId: '1:694782907659:android:eab05a8211b723445afe0e',
    messagingSenderId: '694782907659',
    projectId: 'todo-app-4b079',
    storageBucket: 'todo-app-4b079.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD8zJWzBvMyzj0_jEWlnLnfSV8ghxJoa5Y',
    appId: '1:694782907659:ios:e892d6f52b5ac6025afe0e',
    messagingSenderId: '694782907659',
    projectId: 'todo-app-4b079',
    storageBucket: 'todo-app-4b079.firebasestorage.app',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD8zJWzBvMyzj0_jEWlnLnfSV8ghxJoa5Y',
    appId: '1:694782907659:ios:e892d6f52b5ac6025afe0e',
    messagingSenderId: '694782907659',
    projectId: 'todo-app-4b079',
    storageBucket: 'todo-app-4b079.firebasestorage.app',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA5lxMx3mIEODxWl6pmfMHEQaBh1M3UQvE',
    appId: '1:694782907659:web:e8145de6e6112dd35afe0e',
    messagingSenderId: '694782907659',
    projectId: 'todo-app-4b079',
    authDomain: 'todo-app-4b079.firebaseapp.com',
    storageBucket: 'todo-app-4b079.firebasestorage.app',
    measurementId: 'G-5TS5GZYTPR',
  );
}
