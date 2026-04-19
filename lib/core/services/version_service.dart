// CORE - version_service.dart (version + package_info_plus)
import 'package:version/version.dart';
import 'app_info_service.dart';

class VersionService {
  VersionService._();

  /// So sánh version hiện tại với minVersion từ Remote Config.
  /// Returns true nếu app cần update bắt buộc.
  static bool requiresUpdate(String minVersionString) {
    try {
      final current = Version.parse(AppInfoService.version);
      final minimum = Version.parse(minVersionString);
      return current < minimum;
    } catch (_) {
      return false;
    }
  }

  /// Returns true nếu current >= target (feature flag by version).
  static bool isAtLeast(String targetVersionString) {
    try {
      final current = Version.parse(AppInfoService.version);
      final target = Version.parse(targetVersionString);
      return current >= target;
    } catch (_) {
      return false;
    }
  }
}
