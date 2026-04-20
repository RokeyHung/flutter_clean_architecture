// CORE - theme/app_theme_data.dart
// Abstract contract mọi theme phải implement.
// Để thêm theme mới: tạo class implements AppThemeData, đăng ký vào app_theme_registry.dart.
import 'package:flutter/material.dart';

abstract class AppThemeData {
  /// Unique key dùng để persist + tra cứu trong registry.
  String get id;

  /// Tên hiển thị trong UI (settings screen, theme picker…).
  String get displayName;

  /// Trả về ThemeData cho light mode.
  ThemeData light();

  /// Trả về ThemeData cho dark mode.
  ThemeData dark();
}
