import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/theme/app_theme.dart';

extension BuildContextExtension on BuildContext {
  AppTheme get appTheme => AppTheme.of(this);
}
