import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required bool hasPaymentInfo,
    required bool isConnectingTwitter,
    String? email,
    required bool hasCreatorAccounts,
    required String description,
    required String imageUrl,
    @Default([]) List<SubImage> subImages,
    required bool isRegisteredProfile,
    required bool isRegisteredAddress,
    @Deprecated('Use `role`') @Default(false) bool isReviewer,
    required String name,
    @Default(false) bool isVerified,
    String? gender,
    String? prefecture,
    DateTime? birthDate,
    @Default(false) bool canCreateCommunity,
    String? migrationCode,
    String? ageRange,
    @Deprecated('use `role`') @Default(false) bool isDeveloper,

    /// 比較を行う場合は、UserRole.fromString()を使うこと。
    /// 端末保存時は文字列として保存すること。
    String? role,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class SubImage with _$SubImage {
  const factory SubImage({
    required int id,
    required String imageUrl,
  }) = _SubImage;

  factory SubImage.fromJson(Map<String, dynamic> json) =>
      _$SubImageFromJson(json);
}
