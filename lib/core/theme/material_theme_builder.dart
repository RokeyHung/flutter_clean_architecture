// CORE - theme/material_theme_builder.dart
// Helper tạo TextTheme từ Google Fonts.
// Tách riêng body vs display font để hỗ trợ switch font độc lập.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme buildTextTheme(
  BuildContext context,
  String bodyFont,
  String displayFont,
) {
  final base = Theme.of(context).textTheme;
  final body = GoogleFonts.getTextTheme(bodyFont, base);
  final display = GoogleFonts.getTextTheme(displayFont, base);
  return display.copyWith(
    bodyLarge: body.bodyLarge,
    bodyMedium: body.bodyMedium,
    bodySmall: body.bodySmall,
    labelLarge: body.labelLarge,
    labelMedium: body.labelMedium,
    labelSmall: body.labelSmall,
  );
}
