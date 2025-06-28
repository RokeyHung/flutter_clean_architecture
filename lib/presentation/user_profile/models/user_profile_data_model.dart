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

  // Getters để truy cập dễ dàng các field từ User
  String get name => me?.name ?? '';
  String get description => me?.description ?? '';
  String get imageUrl => me?.imageUrl ?? '';
  bool get isVerified => me?.isVerified ?? false;
  String? get gender => me?.gender;
  String? get ageRange => me?.ageRange;
  List<SubImage> get subImages => me?.subImages ?? [];
  List<UserRecruitment> get userRecruitments =>
      []; // TODO: Implement when needed
  List<UserLink> get userLinks => []; // TODO: Implement when needed
}

@freezed
class UserProfileAction with _$UserProfileAction {
  const factory UserProfileAction.failedToLoad() = _FailedToLoadAction;
}

@freezed
class UserRecruitment with _$UserRecruitment {
  const factory UserRecruitment({
    required String title,
    required String description,
    required DateOption dateOption,
  }) = _UserRecruitment;
}

@freezed
class DateOption with _$DateOption {
  const factory DateOption({
    required String title,
  }) = _DateOption;
}

@freezed
class UserLink with _$UserLink {
  const factory UserLink({
    required String type,
    required String userName,
  }) = _UserLink;
}

enum Gender {
  male,
  female,
  other,
}
