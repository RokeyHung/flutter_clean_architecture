import 'package:flutter_clean_architecture/core/clean/interactor.dart';
import 'package:flutter_clean_architecture/core/clean/presenter.dart';
import 'package:flutter_clean_architecture/domain/gateway/user_repository.dart';
import 'package:flutter_clean_architecture/domain/use_case/user_address_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileInteractorProvider = Provider.autoDispose
    .family<UserProfileInteractor, Presenter<UserAddressUseCaseOutput>>(
  (ref, presenter) => UserProfileInteractor(
    presenter,
    ref.watch(userRepositoryProvider),
  ),
);

class UserProfileInteractor
    extends Interactor<UserAddressUseCaseOutput, UserAddressUseCaseInput> {
  UserProfileInteractor(
    Presenter<UserAddressUseCaseOutput> presenter,
    this.userRepository,
  ) : super(presenter);

  final UserRepository userRepository;

  @override
  Future<void> call(UserAddressUseCaseInput input) async {
    await input.when(
      load: (userId) async {
        send(output: const UserAddressUseCaseOutput.loading());

        final result = await userRepository.getUser(id: userId);

        result.either(
          (error) {
            send(output: UserAddressUseCaseOutput.loadFailure(failure: error));
            return error;
          },
          (data) {
            send(
              output: UserAddressUseCaseOutput.loadSuccess(
                user: data,
              ),
            );
            return data;
          },
        );
      },
    );
  }
}
