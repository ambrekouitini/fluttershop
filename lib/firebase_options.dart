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
    apiKey: 'AIzaSyDDRRVu8tH4XhnazfsEdmqpqtEfO3Q0UDk',
    appId: '1:238491656384:web:175fbb32e6f37106ef4d25',
    messagingSenderId: '238491656384',
    projectId: 'shopflutter-73311',
    authDomain: 'shopflutter-73311.firebaseapp.com',
    storageBucket: 'shopflutter-73311.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDEMO_API_KEY_FOR_DEVELOPMENT',
    appId: '1:123456789:android:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'hello-kitty-store-demo',
    storageBucket: 'hello-kitty-store-demo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEMO_API_KEY_FOR_DEVELOPMENT',
    appId: '1:123456789:ios:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'hello-kitty-store-demo',
    storageBucket: 'hello-kitty-store-demo.appspot.com',
    iosBundleId: 'com.example.shopFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEMO_API_KEY_FOR_DEVELOPMENT',
    appId: '1:123456789:macos:abcdef123456',
    messagingSenderId: '123456789',
    projectId: 'hello-kitty-store-demo',
    storageBucket: 'hello-kitty-store-demo.appspot.com',
    iosBundleId: 'com.example.shopFlutter',
  );
}
