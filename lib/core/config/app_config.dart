// CORE - config/app_config.dart
// Compile-time configuration — KHÔNG dùng .env, KHÔNG dùng dart-define string.
// Mỗi môi trường là 1 Dart class → type-safe, IDE autocomplete đầy đủ.
//
// Để thêm môi trường mới (ví dụ staging):
//   1. Tạo class StagingConfig extends AppConfig
//   2. Tạo firebase_options_staging.dart (flutterfire configure ...)
//   3. Tạo lib/main_staging.dart
//   4. Thêm flavor vào build.gradle.kts + Makefile
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options_dev.dart';
import 'firebase_options_prod.dart';

// ── Abstract contract ─────────────────────────────────────────────────────────

abstract class AppConfig {
  /// Tên môi trường hiển thị trong debug banner / logs.
  String get name;

  /// FirebaseOptions cho môi trường này.
  FirebaseOptions get firebaseOptions;

  /// Base URL của REST API.
  String get apiBaseUrl;

  /// Bật Dio LogInterceptor — chỉ nên bật ở dev.
  bool get enableApiLogging;

  /// Bật Firebase Crashlytics collection.
  bool get enableCrashlytics;

  /// Bật Firebase Performance tracing.
  bool get enablePerformanceTracing;

  /// Dùng AndroidDebugProvider / AppleDebugProvider cho AppCheck.
  /// Prod nên dùng PlayIntegrityProvider / DeviceCheckProvider.
  bool get useDebugAppCheck;

  /// Hiển thị debug banner trên app.
  bool get showDebugBanner;

  /// Connect timeout của Dio.
  Duration get connectTimeout;

  /// Receive timeout của Dio.
  Duration get receiveTimeout;

  // Tiện ích kiểm tra nhanh
  bool get isDev => name == 'dev';
  bool get isProd => name == 'prod';
}

// ── Dev ───────────────────────────────────────────────────────────────────────

class DevConfig extends AppConfig {
  @override
  String get name => 'dev';

  @override
  FirebaseOptions get firebaseOptions => FirebaseOptionsdev.currentPlatform;

  @override
  String get apiBaseUrl => 'https://dev-api.example.com';

  @override
  bool get enableApiLogging => true;

  @override
  bool get enableCrashlytics => false;

  @override
  bool get enablePerformanceTracing => false;

  @override
  bool get useDebugAppCheck => true;

  @override
  bool get showDebugBanner => true;

  @override
  Duration get connectTimeout => const Duration(seconds: 30);

  @override
  Duration get receiveTimeout => const Duration(seconds: 30);
}

// ── Prod ──────────────────────────────────────────────────────────────────────

class ProdConfig extends AppConfig {
  @override
  String get name => 'prod';

  @override
  FirebaseOptions get firebaseOptions => FirebaseOptionsProd.currentPlatform;

  @override
  String get apiBaseUrl => 'https://api.example.com';

  @override
  bool get enableApiLogging => kDebugMode; // false khi release build

  @override
  bool get enableCrashlytics => true;

  @override
  bool get enablePerformanceTracing => true;

  @override
  bool get useDebugAppCheck => false;

  @override
  bool get showDebugBanner => false;

  @override
  Duration get connectTimeout => const Duration(seconds: 15);

  @override
  Duration get receiveTimeout => const Duration(seconds: 15);
}
