import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_body.freezed.dart';
part 'signup_body.g.dart';

@freezed
class SignUpBody with _$SignUpBody {
  factory SignUpBody({
    String? migrationCode,
  }) = _SignUpBody;

  factory SignUpBody.fromJson(Map<String, dynamic> json) =>
      _$SignUpBodyFromJson(json);
}
