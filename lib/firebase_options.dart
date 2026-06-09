import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfWAHdAOrmF2dDNXTA5so-4ci1u43nF8I',
    appId: '1:711906496064:android:507da295f35a4dd2a599a5',
    messagingSenderId: '711906496064',
    projectId: 'map-49d59',
    storageBucket: 'map-49d59.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfWAHdAOrmF2dDNXTA5so-4ci1u43nF8I',
    appId: '1:711906496064:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '711906496064',
    projectId: 'map-49d59',
    storageBucket: 'map-49d59.firebasestorage.app',
    iosBundleId: 'com.example.alarmClockApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCfWAHdAOrmF2dDNXTA5so-4ci1u43nF8I',
    appId: '1:711906496064:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '711906496064',
    projectId: 'map-49d59',
    storageBucket: 'map-49d59.firebasestorage.app',
    iosBundleId: 'com.example.alarmClockApp',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCfWAHdAOrmF2dDNXTA5so-4ci1u43nF8I',
    appId: '1:711906496064:web:YOUR_WEB_APP_ID',
    messagingSenderId: '711906496064',
    projectId: 'map-49d59',
    authDomain: 'map-49d59.firebaseapp.com',
    storageBucket: 'map-49d59.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCfWAHdAOrmF2dDNXTA5so-4ci1u43nF8I',
    appId: '1:711906496064:web:YOUR_WEB_APP_ID',
    messagingSenderId: '711906496064',
    projectId: 'map-49d59',
    authDomain: 'map-49d59.firebaseapp.com',
    storageBucket: 'map-49d59.firebasestorage.app',
  );
}
