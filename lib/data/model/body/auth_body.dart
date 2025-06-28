import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_body.freezed.dart';
part 'auth_body.g.dart';

@freezed
class LoginBody with _$LoginBody {
  const factory LoginBody({
    required String email,
    required String password,
  }) = _LoginBody;

  factory LoginBody.fromJson(Map<String, dynamic> json) =>
      _$LoginBodyFromJson(json);
}

@freezed
class RegisterBody with _$RegisterBody {
  const factory RegisterBody({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) = _RegisterBody;

  factory RegisterBody.fromJson(Map<String, dynamic> json) =>
      _$RegisterBodyFromJson(json);
}
