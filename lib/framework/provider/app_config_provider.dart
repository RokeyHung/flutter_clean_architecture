import 'package:flutter_clean_architecture/core/config/app_config.dart';
import 'package:flutter_clean_architecture/core/config/environment_manager.dart';
import 'package:flutter_clean_architecture/framework/provider/environment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to determine current environment
final environmentProvider = Provider<Environment>((ref) {
  return EnvironmentManager.currentEnvironment;
});

final appConfigProvider = Provider<AppConfig>((ref) {
  final environment = ref.watch(currentEnvironmentProvider);

  switch (environment) {
    case Environment.development:
      return AppConfig(
        appName: 'Flutter Clean Architecture (Dev)',
        companyName: 'Your Company',
        baseUrl: 'https://api-dev.example.com/v1',
        environment: environment,
        enableLogging: true,
      );

    case Environment.staging:
      return AppConfig(
        appName: 'Flutter Clean Architecture (Staging)',
        companyName: 'Your Company',
        baseUrl: 'https://api-staging.example.com/v1',
        environment: environment,
        enableLogging: true,
      );

    case Environment.production:
      return AppConfig(
        appName: 'Flutter Clean Architecture',
        companyName: 'Your Company',
        baseUrl: 'https://api.example.com/v1',
        environment: environment,
        enableLogging: false,
      );
  }
});
