import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_clean_architecture/core/network/network_exception.dart';
import 'package:flutter_clean_architecture/core/utils/data_result.dart';
import 'package:flutter_clean_architecture/data/data_sources/user_data_source.dart';
import 'package:flutter_clean_architecture/data/model/user.dart';
import 'package:riverpod/riverpod.dart';

final userRepositoryProvider = Provider.autoDispose<UserRepository>(
  (ref) => UserRepositoryImpl(
    ref.watch(userDataSourceProvider),
  ),
);

abstract class UserRepository {
  Future<DataResult<User>> login();
  Future<DataResult<User>> getUser({required int id});
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(
    this.userDataSource,
  );

  final UserDataSource userDataSource;

  @override
  Future<DataResult<User>> login() async {
    try {
      final user = await userDataSource.login();
      FirebaseCrashlytics.instance.setUserIdentifier(user.id.toString());
      return DataResult.success(user);
    } on DioException catch (e, stackTrace) {
      return DataResult.failure(
        NetworkFailure.fromDioException(e),
        stackTrace,
      );
    }
  }

  @override
  Future<DataResult<User>> getUser({required int id}) async {
    try {
      final user = await userDataSource.getUser(userId: id);
      return DataResult.success(user);
    } on DioException catch (e, stackTrace) {
      return DataResult.failure(
        NetworkFailure.fromDioException(e),
        stackTrace,
      );
    }
  }
}
