// CORE - firebase_service.dart
import 'dart:ui';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart' show FlutterError;

class FirebaseService {
  FirebaseService._();

  static Future<void> init() async {
    await Firebase.initializeApp();

    // App Check
    await FirebaseAppCheck.instance.activate(
      providerAndroid: const AndroidDebugProvider(),
      providerApple: const AppleDebugProvider(),
    );

    // Crashlytics — catch Flutter + async errors
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Performance tracing
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  }

  static FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;
  static FirebasePerformance get performance => FirebasePerformance.instance;
}
