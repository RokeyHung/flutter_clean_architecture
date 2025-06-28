import 'package:flutter/material.dart';

class AppTheme {
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const AppTheme({
    required this.colorScheme,
    required this.textTheme,
  });

  static AppTheme of(BuildContext context) {
    final theme = Theme.of(context);
    return AppTheme(
      colorScheme: theme.colorScheme,
      textTheme: theme.textTheme,
    );
  }
}

extension AppThemeColorScheme on ColorScheme {
  Color get materialsLabel => primary;
  Color get base => primary;
  Color get label => onSurface;
  Color get background => surface;
  Color get defaultScheme => primary;

  // Additional color properties
  Color get primary => this.primary;
  Color get secondary => this.secondary;
  Color get surface => this.surface;
  Color get onSurface => this.onSurface;
  Color get white => Colors.white;
  Color get tertiary => outline;
}

extension AppThemeTextTheme on TextTheme {
  TextStyle get p12 => bodySmall ?? const TextStyle(fontSize: 12);
  TextStyle get p13 => bodyMedium ?? const TextStyle(fontSize: 13);
  TextStyle get p16 => bodyLarge ?? const TextStyle(fontSize: 16);
  TextStyle get p20 => titleLarge ?? const TextStyle(fontSize: 20);
}
