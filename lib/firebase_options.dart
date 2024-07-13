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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'it not supported by FlutLab yet, but you can add it manually',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'it not supported by FlutLab yet, but you can add it manually',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'it not supported by FlutLab yet, but you can add it manually',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'it not supported by FlutLab yet, but you can add it manually',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCC8OcQUyaOliR3XEv_qetWIJO0C8Zb2bE',
    appId: '1:210025230234:android:9b078c8cdd9c8430795423',
    messagingSenderId: '210025230234',
    projectId: 'hipnos-fantaso',
    storageBucket: 'hipnos-fantaso.appspot.com',
    databaseURL: "https://hipnos-fantaso-default-rtdb.firebaseio.com",
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAUrm1sgkuatUomPZyMjA5je_mvhOYgbT4",
    authDomain: "hipnos-fantaso.firebaseapp.com",
    projectId: "hipnos-fantaso",
    storageBucket: "hipnos-fantaso.appspot.com",
    messagingSenderId: "210025230234",
    appId: "1:210025230234:web:802c85c430045ba7795423",
    databaseURL: "https://hipnos-fantaso-default-rtdb.firebaseio.com",
  );
}
