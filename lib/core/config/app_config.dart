import 'package:flutter/foundation.dart';

enum Environment {
  development,
  staging,
  production,
}

class AppConfig with Diagnosticable {
  final String appName;
  final String companyName;
  final String baseUrl;
  final Environment environment;
  final int connectTimeout;
  final int receiveTimeout;
  final bool enableLogging;

  AppConfig({
    required this.appName,
    required this.companyName,
    required this.baseUrl,
    required this.environment,
    this.connectTimeout = 30000, // 30 seconds
    this.receiveTimeout = 30000, // 30 seconds
    this.enableLogging = true,
  });

  bool get isDevelopment => environment == Environment.development;
  bool get isStaging => environment == Environment.staging;
  bool get isProduction => environment == Environment.production;

  // Default headers for API requests
  Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'User-Agent': 'FlutterApp/1.0.0',
      };

  // Feature flags
  bool get enableAnalytics => isProduction;
  bool get enableCrashlytics => isProduction;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('appName', appName));
    properties.add(StringProperty('companyName', companyName));
    properties.add(StringProperty('baseUrl', baseUrl));
    properties.add(EnumProperty('environment', environment));
  }
}
