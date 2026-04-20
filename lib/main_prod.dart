// Entry point: PROD
// Chạy: flutter run --flavor prod --target lib/main_prod.dart
//        make run-prod
import 'core/config/app_config.dart';
import 'main.dart';

void main() => bootstrap(ProdConfig());
