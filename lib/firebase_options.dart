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
    apiKey: 'AIzaSyABPI1nQdwu87c-XPiC5WAXT4V2b5jtXLQ',
    appId: '1:135150273921:web:072d3b0d0da891ad5b9480',
    messagingSenderId: '135150273921',
    projectId: 'expense-todo-1de6f',
    authDomain: 'expense-todo-1de6f.firebaseapp.com',
    storageBucket: 'expense-todo-1de6f.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBFoJJs_yefuWiEyMM80yDe43UlLCIosQk',
    appId: '1:135150273921:android:7080280352285d7b5b9480',
    messagingSenderId: '135150273921',
    projectId: 'expense-todo-1de6f',
    storageBucket: 'expense-todo-1de6f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBnwfekxVzDZJzYrOyd3upqovW1qyW1rYE',
    appId: '1:135150273921:ios:10f94359e605e12b5b9480',
    messagingSenderId: '135150273921',
    projectId: 'expense-todo-1de6f',
    storageBucket: 'expense-todo-1de6f.firebasestorage.app',
    iosBundleId: 'com.example.expenseTodoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBnwfekxVzDZJzYrOyd3upqovW1qyW1rYE',
    appId: '1:135150273921:ios:10f94359e605e12b5b9480',
    messagingSenderId: '135150273921',
    projectId: 'expense-todo-1de6f',
    storageBucket: 'expense-todo-1de6f.firebasestorage.app',
    iosBundleId: 'com.example.expenseTodoApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyABPI1nQdwu87c-XPiC5WAXT4V2b5jtXLQ',
    appId: '1:135150273921:web:7fb6b895261c17a95b9480',
    messagingSenderId: '135150273921',
    projectId: 'expense-todo-1de6f',
    authDomain: 'expense-todo-1de6f.firebaseapp.com',
    storageBucket: 'expense-todo-1de6f.firebasestorage.app',
  );
}
