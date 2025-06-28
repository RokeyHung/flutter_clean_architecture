import 'package:flutter_clean_architecture/data/data_sources/remote/user_data_source.dart';
import 'package:riverpod/riverpod.dart';

final userRepositoryProvider = Provider.autoDispose<UserRepository>(
  (ref) => UserRepositoryImpl(
    ref.watch(userDataSourceProvider),
  ),
);

abstract class UserRepository {
  // Future<DataResult<UserEntity>> getUser({required int id});
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this.userDataSource);

  final UserDataSource userDataSource;

  // @override
  // Future<DataResult<UserEntity>> getUser({required int id}) async {}
}
