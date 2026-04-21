// CORE - utils/app_logger.dart
//
// Structured logger cho toàn app.
//
// Usage:
//   AppLogger.d('Todo loaded', tag: 'TodoNotifier');
//   AppLogger.e('API failed', error: e, stackTrace: st);
//
// - Dev  : xuất màu đẹp ra console
// - Prod : error/fatal → gửi lên Firebase Crashlytics
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Wrapper mỏng quanh `logger` package, tích hợp Crashlytics ở prod.
class AppLogger {
  AppLogger._();

  static late final Logger _logger;
  static bool _crashlyticsEnabled = false;

  // ── Init ────────────────────────────────────────────────────────────────────

  /// Gọi một lần trong `main()` sau khi FirebaseService.init() xong.
  ///
  /// [enableCrashlytics] nên = `config.enableCrashlytics`.
  /// [logLevel] nên = `config.logLevel`.
  static void init({
    bool enableCrashlytics = false,
    Level logLevel = Level.debug,
  }) {
    _crashlyticsEnabled = enableCrashlytics;
    _logger = Logger(
      printer: kDebugMode
          ? PrettyPrinter(
              methodCount: 1,
              errorMethodCount: 8,
              lineLength: 90,
              colors: true,
              printEmojis: true,
              dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
            )
          : SimplePrinter(colors: false, printTime: true),
      filter: kDebugMode ? DevelopmentFilter() : ProductionFilter(),
      output: kDebugMode ? ConsoleOutput() : _CrashlyticsOutput(),
      level: logLevel,
    );
  }

  // ── Public API ──────────────────────────────────────────────────────────────

  /// Debug — chỉ hiện ở dev.
  static void d(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.d(_format(tag, message), error: error, stackTrace: stackTrace);
  }

  /// Info.
  static void i(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.i(_format(tag, message), error: error, stackTrace: stackTrace);
  }

  /// Warning.
  static void w(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.w(_format(tag, message), error: error, stackTrace: stackTrace);
  }

  /// Error — gửi lên Crashlytics nếu đã bật.
  static void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.e(_format(tag, message), error: error, stackTrace: stackTrace);
    if (_crashlyticsEnabled && error != null) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: _format(tag, message),
      );
    }
  }

  /// Fatal — luôn gửi Crashlytics (kể cả dev nếu bật).
  static void wtf(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _logger.f(_format(tag, message), error: error, stackTrace: stackTrace);
    if (error != null) {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: _format(tag, message),
        fatal: true,
      );
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  static String _format(String? tag, String message) =>
      tag != null ? '[$tag] $message' : message;
}

// ── Production output: silent (Crashlytics handled manually above) ───────────

class _CrashlyticsOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Prod logs đã được gửi qua Crashlytics.recordError trong AppLogger.e/wtf.
    // Không in ra console để tránh leak thông tin.
  }
}
