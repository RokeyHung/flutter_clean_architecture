import 'dart:async';

import 'package:flutter_clean_architecture/core/clean/presenter.dart';
import 'package:flutter_clean_architecture/domain/use_case/user_address_use_case.dart';
import 'package:flutter_clean_architecture/presentation/user_profile/models/user_profile_data_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfilePresenter = StateNotifierProvider.autoDispose
    .family<UserProfilePresenter, UserProfileDataModel, int>(
  (ref, id) => UserProfilePresenter(id: id),
);

class UserProfilePresenter extends StateNotifier<UserProfileDataModel>
    implements Presenter<UserAddressUseCaseOutput> {
  UserProfilePresenter({
    required int id,
  }) : super(UserProfileDataModel(id: id));

  Stream<UserProfileAction> get actions => _actionsController.stream;
  final _actionsController = StreamController<UserProfileAction>();

  @override
  void dispose() {
    _actionsController.close();
    super.dispose();
  }

  @override
  void present({required UserAddressUseCaseOutput response}) {
    response.when(
      loading: () => state = state.copyWith(isLoading: true),
      loadFailure: (failure) {
        _actionsController.add(
          const UserProfileAction.failedToLoad(),
        );
      },
      loadSuccess: (user) {
        state = state.copyWith(
          isLoading: false,
          me: user,
        );
      },
    );
  }
}
