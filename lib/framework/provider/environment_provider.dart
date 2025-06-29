import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clean_architecture/core/config/environment_manager.dart';
import 'package:flutter_clean_architecture/core/config/app_config.dart';

// Provider to access current environment
final currentEnvironmentProvider = Provider<Environment>((ref) {
  return EnvironmentManager.currentEnvironment;
});

// Provider to check environment type
final isDevelopmentProvider = Provider<bool>((ref) {
  return EnvironmentManager.isDevelopment;
});

final isStagingProvider = Provider<bool>((ref) {
  return EnvironmentManager.isStaging;
});

final isProductionProvider = Provider<bool>((ref) {
  return EnvironmentManager.isProduction;
}); 