// CORE - settings/app_settings.dart
// Freezed state lưu lựa chọn theme và font của user.
// Single-variant → dùng abstract class (Freezed v3 convention).
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    /// ID theme đang dùng — phải khớp key trong buildThemeRegistry().
    @Default('aurora_eternal_frost') String themeId,

    /// Font cho body text (bodyLarge/Medium/Small, label*).
    @Default('Inter') String fontBody,

    /// Font cho display/headline text.
    @Default('Inter') String fontDisplay,
  }) = _AppSettings;
}
