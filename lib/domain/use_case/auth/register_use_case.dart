import 'package:flutter_clean_architecture/core/utils/data_result.dart';
import 'package:flutter_clean_architecture/data/model/body/auth_body.dart';
import 'package:flutter_clean_architecture/domain/entity/auth_entity.dart';
import 'package:flutter_clean_architecture/domain/repository/auth_repository.dart';
import 'package:riverpod/riverpod.dart';

final registerUseCaseProvider = Provider.autoDispose<RegisterUseCase>(
  (ref) => RegisterUseCase(
    ref.watch(authRepositoryProvider),
  ),
);

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<DataResult<AuthEntity>> execute({
    required RegisterBody body,
    required bool agreedToPolicy,
  }) async {
    if (!agreedToPolicy) {
      return DataResult.failure(
        const ResultFailure('Bạn phải đồng ý với chính sách để tiếp tục.'),
      );
    }

    return await repository.register(body);
  }
}
