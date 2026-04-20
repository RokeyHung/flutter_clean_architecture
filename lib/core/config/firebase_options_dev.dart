// CORE - config/firebase_options_dev.dart
// Chạy lệnh sau để generate file này tự động từ Firebase Console:
//   flutterfire configure --project=your-project-dev --out=lib/core/config/firebase_options_dev.dart
//
// Sau khi generate xong, XÓA file placeholder này và KHÔNG commit file thật lên git
// (đã được gitignore qua firebase_options_*.dart nếu bạn muốn bảo mật).
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class FirebaseOptionsdev {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'FirebaseOptions chưa được cấu hình cho platform: $defaultTargetPlatform',
        );
    }
  }

  /// TODO: Thay thế bằng giá trị thật từ Firebase Console (dev project)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_DEV_ANDROID_API_KEY',
    appId: '1:YOUR_DEV_PROJECT_NUMBER:android:XXXXXXXXXXXXXXXXXX',
    messagingSenderId: 'YOUR_DEV_PROJECT_NUMBER',
    projectId: 'your-project-dev',
    storageBucket: 'your-project-dev.appspot.com',
  );

  /// TODO: Thay thế bằng giá trị thật từ Firebase Console (dev project)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_DEV_IOS_API_KEY',
    appId: '1:YOUR_DEV_PROJECT_NUMBER:ios:XXXXXXXXXXXXXXXXXX',
    messagingSenderId: 'YOUR_DEV_PROJECT_NUMBER',
    projectId: 'your-project-dev',
    storageBucket: 'your-project-dev.appspot.com',
    iosBundleId: 'com.hhungnm.cleanarch.flutterCleanArchitecture.dev',
  );
}
