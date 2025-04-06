import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDEw9t4LgUTP99wdMic6-WhPSIqEob6GbI',
    appId: '1:213151631397:android:06bb0865a97b69145597cc',
    messagingSenderId: '213151631397',
    projectId: 'myyojana-d0da4',
    storageBucket: 'myyojana-d0da4.firebasestorage.app',
    androidClientId: '213151631397-utvgrr4oinokj5dcvr2e5gna08eqf2eb.apps.googleusercontent.com',
  );
}
