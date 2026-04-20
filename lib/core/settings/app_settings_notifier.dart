// CORE - settings/app_settings_notifier.dart
// Riverpod 3 Notifier — đọc/ghi AppSettings qua SharedPreferences.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/core_providers.dart';
import 'app_settings.dart';

class AppSettingsNotifier extends Notifier<AppSettings> {
  static const _kThemeId = 'settings_theme_id';
  static const _kFontBody = 'settings_font_body';
  static const _kFontDisplay = 'settings_font_display';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  AppSettings build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return AppSettings(
      themeId: prefs.getString(_kThemeId) ?? 'aurora_eternal_frost',
      fontBody: prefs.getString(_kFontBody) ?? 'Inter',
      fontDisplay: prefs.getString(_kFontDisplay) ?? 'Inter',
    );
  }

  /// Đổi theme. [id] phải là key hợp lệ trong buildThemeRegistry().
  Future<void> setTheme(String id) async {
    await _prefs.setString(_kThemeId, id);
    state = state.copyWith(themeId: id);
  }

  /// Đổi font. Có thể chỉ truyền một trong hai.
  Future<void> setFont({String? body, String? display}) async {
    if (body != null) await _prefs.setString(_kFontBody, body);
    if (display != null) await _prefs.setString(_kFontDisplay, display);
    state = state.copyWith(
      fontBody: body ?? state.fontBody,
      fontDisplay: display ?? state.fontDisplay,
    );
  }
}

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);
