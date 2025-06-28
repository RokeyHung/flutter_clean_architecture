import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_clean_architecture/core/utils/data_result.dart';
import 'package:flutter_clean_architecture/data/data_sources/remote/auth_data_source.dart';
import 'package:flutter_clean_architecture/data/mappers/auth_mapper.dart';
import 'package:flutter_clean_architecture/data/model/body/auth_body.dart';
import 'package:flutter_clean_architecture/domain/entity/auth_entity.dart';
import 'package:flutter_clean_architecture/framework/network/network_exception.dart';
import 'package:riverpod/riverpod.dart';

final authRepositoryProvider = Provider.autoDispose<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(authDataSourceProvider),
  ),
);

abstract class AuthRepository {
  Future<DataResult<AuthEntity>> login(LoginBody body);
  Future<DataResult<AuthEntity>> register(RegisterBody body);
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.dataSource);

  final AuthDataSource dataSource;

  @override
  Future<DataResult<AuthEntity>> login(LoginBody body) async {
    try {
      final authModel = await dataSource.login(body);
      final authEntity = authModel.toEntity();

      FirebaseCrashlytics.instance.setUserIdentifier(authEntity.user.id);

      return DataResult.success(authEntity);
    } on DioException catch (e, stackTrace) {
      return DataResult.failure(
        NetworkFailure.fromDioException(e),
        stackTrace,
      );
    }
  }

  @override
  Future<DataResult<AuthEntity>> register(RegisterBody body) async {
    try {
      final authModel = await dataSource.register(body);
      final authEntity = authModel.toEntity();

      FirebaseCrashlytics.instance.setUserIdentifier(authEntity.user.id);

      return DataResult.success(authEntity);
    } on DioException catch (e, stackTrace) {
      return DataResult.failure(
        NetworkFailure.fromDioException(e),
        stackTrace,
      );
    }
  }
}
