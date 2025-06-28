import 'package:flutter_clean_architecture/domain/interactor/user_profile_interactor.dart';
import 'package:flutter_clean_architecture/domain/use_case/user_address_use_case.dart';
import 'package:flutter_clean_architecture/presentation/user_profile/user_profile_presenter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileControllerProvider =
    Provider.autoDispose.family<UserProfileController, UserProfilePresenter>(
  (ref, presenter) => UserProfileController(
    presenter,
    ref.watch(userProfileInteractorProvider(presenter)),
  ),
);

class UserProfileController {
  const UserProfileController(
    this._presenter,
    this._interactor,
  );

  final UserProfilePresenter _presenter;
  final UserProfileInteractor _interactor;

  Future<void> load({
    required int userId,
  }) async {
    _interactor(UserAddressUseCaseInput.load(userId: userId));
  }
}
