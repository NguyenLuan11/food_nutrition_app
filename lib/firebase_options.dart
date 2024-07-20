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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBWptIAbbl8nbPnJuPnR_ZnoE8g3qi9dbM',
    appId: '1:826646183246:web:a06a639b5d8e40455e321f',
    messagingSenderId: '826646183246',
    projectId: 'food-nutrition-app-170502',
    authDomain: 'food-nutrition-app-170502.firebaseapp.com',
    storageBucket: 'food-nutrition-app-170502.appspot.com',
    measurementId: 'G-CD07Z4LM10',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBI_FAKmbrLt80EaqNxgzAN7SC9JrOSekY',
    appId: '1:826646183246:android:002110436041ae075e321f',
    messagingSenderId: '826646183246',
    projectId: 'food-nutrition-app-170502',
    storageBucket: 'food-nutrition-app-170502.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAm3ywnv5tH8bu5S7dsmmSWA5Aze7a1-OA',
    appId: '1:826646183246:ios:4a61335fe1381bb65e321f',
    messagingSenderId: '826646183246',
    projectId: 'food-nutrition-app-170502',
    storageBucket: 'food-nutrition-app-170502.appspot.com',
    iosClientId:
        '826646183246-gff0of6l1j4vidhkb9kadh25g4ts2m8c.apps.googleusercontent.com',
    iosBundleId: 'com.nguyenluan.foodNutritionApp',
  );
}
