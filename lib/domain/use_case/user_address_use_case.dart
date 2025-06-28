import 'package:flutter_clean_architecture/core/clean/use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_address_use_case.freezed.dart';

@freezed
class UserAddressUseCaseInput
    with _$UserAddressUseCaseInput
    implements UseCaseInput {
  const factory UserAddressUseCaseInput.load({
    required int userId,
  }) = _LoadUserAddressUseCaseInput;
}

@freezed
class UserAddressUseCaseOutput
    with _$UserAddressUseCaseOutput
    implements UseCaseOutput {
  const factory UserAddressUseCaseOutput.loading() =
      _LoadingUserAddressUseCaseOutput;
  const factory UserAddressUseCaseOutput.loadFailure({
    required Exception failure,
  }) = _LoadFailureUserAddressUseCaseOutput;
  const factory UserAddressUseCaseOutput.loadSuccess() =
      _LoadiSuccessAddressUseCaseOutput;
}
