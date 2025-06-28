import 'package:flutter_clean_architecture/data/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_data_model.freezed.dart';

@freezed
class UserProfileDataModel with _$UserProfileDataModel {
  const UserProfileDataModel._();
  const factory UserProfileDataModel({
    @Default(0) int id,
    @Default(true) bool isLoading,
    @Default(null) User? me,
  }) = _UserProfileDataModel;
}

@freezed
class UserProfileAction with _$UserProfileAction {
  const factory UserProfileAction.failedToLoad() = _FailedToLoadAction;
}
