// CORE - theme/app_theme_registry.dart
// Registry của tất cả theme trong app.
// Để thêm theme mới:
//   1. Tạo class implements AppThemeData trong lib/core/theme/themes/
//   2. Import và thêm vào map bên dưới.
//   3. Gọi ref.read(appSettingsProvider.notifier).setTheme('<id>') từ UI.
import 'package:flutter/material.dart';
import 'app_theme_data.dart';
import 'themes/aurora_eternal_frost_theme.dart';

const String defaultThemeId = 'aurora_eternal_frost';

/// Trả về toàn bộ danh sách theme đã đăng ký.
/// TextTheme được truyền vào khi build để hỗ trợ Google Fonts dynamic.
Map<String, AppThemeData> buildThemeRegistry(TextTheme textTheme) {
  return {
    'aurora_eternal_frost': AuroraEternalFrostTheme(textTheme),
    // Thêm theme mới ở đây, ví dụ:
    // 'midnight_ember': MidnightEmberTheme(textTheme),
  };
}
