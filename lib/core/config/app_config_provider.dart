// CORE - config/app_config_provider.dart
// Provider duy nhất để truy cập AppConfig trong toàn app.
// Được override bằng DevConfig / ProdConfig tại ProviderScope trong main_*.dart.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => throw UnimplementedError(
    'Override appConfigProvider in ProviderScope — see main_dev.dart / main_prod.dart',
  ),
);
