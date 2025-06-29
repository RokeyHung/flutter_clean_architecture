import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/core/config/app_config.dart';

class EnvironmentManager {
  static Environment _currentEnvironment = Environment.development;

  static Environment get currentEnvironment => _currentEnvironment;

  static void setEnvironment(Environment environment) {
    _currentEnvironment = environment;
    debugPrint('🌍 Environment set to: $environment');
  }

  static bool get isDevelopment =>
      _currentEnvironment == Environment.development;
  static bool get isStaging => _currentEnvironment == Environment.staging;
  static bool get isProduction => _currentEnvironment == Environment.production;

  // Helper method to get environment from build configuration
  static Environment getEnvironmentFromBuildConfig() {
    // You can customize this based on your build configuration
    // For example, using different flavors or build types

    if (kDebugMode) {
      return Environment.development;
    } else if (kReleaseMode) {
      // You can add more logic here to determine staging vs production
      return Environment.production;
    } else {
      return Environment.staging;
    }
  }

  // Method to initialize environment
  static void initialize() {
    final env = getEnvironmentFromBuildConfig();
    setEnvironment(env);
  }
}
