import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    // form fields
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default(false) bool agreedToPolicy,

    // status
    @Default(false) bool isLoading,
    @Default(null) String? errorMessage,
  }) = _RegisterState;
}
