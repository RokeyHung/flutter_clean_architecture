// CORE - remote_config_service.dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _rc;

  RemoteConfigService(this._rc);

  static Future<RemoteConfigService> init() async {
    final rc = FirebaseRemoteConfig.instance;
    await rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await rc.setDefaults({
      'todo_max_title_length': 100,
      'todo_enable_ai_suggestions': false,
      'maintenance_mode': false,
      'app_min_version': '0.1.0',
    });
    await rc.fetchAndActivate();
    return RemoteConfigService(rc);
  }

  int get todoMaxTitleLength => _rc.getInt('todo_max_title_length');
  bool get enableAiSuggestions => _rc.getBool('todo_enable_ai_suggestions');
  bool get maintenanceMode => _rc.getBool('maintenance_mode');
  String get appMinVersion => _rc.getString('app_min_version');
}
