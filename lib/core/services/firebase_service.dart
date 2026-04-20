// CORE - firebase_service.dart
import 'dart:ui';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart' show FlutterError;
import '../config/app_config.dart';

class FirebaseService {
  FirebaseService._();

  static Future<void> init(AppConfig config) async {
    await Firebase.initializeApp(options: config.firebaseOptions);

    // App Check — debug provider cho dev, Play Integrity / DeviceCheck cho prod
    await FirebaseAppCheck.instance.activate(
      providerAndroid: config.useDebugAppCheck
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
      providerApple: config.useDebugAppCheck
          ? const AppleDebugProvider()
          : const AppleDeviceCheckProvider(),
    );

    // Crashlytics
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      config.enableCrashlytics,
    );
    if (config.enableCrashlytics) {
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;
      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    // Performance tracing
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(
      config.enablePerformanceTracing,
    );
  }

  static FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;
  static FirebasePerformance get performance => FirebasePerformance.instance;
}
