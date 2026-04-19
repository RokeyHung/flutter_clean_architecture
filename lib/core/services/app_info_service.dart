// CORE - app_info_service.dart (package_info_plus)
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  AppInfoService._();

  static PackageInfo? _info;

  static Future<void> init() async {
    _info = await PackageInfo.fromPlatform();
  }

  static String get appName => _info?.appName ?? '';
  static String get version => _info?.version ?? '';
  static String get buildNumber => _info?.buildNumber ?? '';
  static String get versionDisplay => 'v$version ($buildNumber)';
  static String get packageName => _info?.packageName ?? '';
}
