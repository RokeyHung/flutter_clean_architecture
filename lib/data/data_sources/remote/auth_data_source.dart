import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/data/model/auth_model.dart';
import 'package:flutter_clean_architecture/data/model/body/auth_body.dart';
import 'package:flutter_clean_architecture/data/model/user_model.dart';
import 'package:flutter_clean_architecture/framework/provider/dio_provider.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod/riverpod.dart';

part 'auth_data_source.g.dart';

final authDataSourceProvider = Provider<AuthDataSource>(
  (ref) => AuthDataSource(ref.watch(dioProvider)),
);

@RestApi()
abstract class AuthDataSource {
  factory AuthDataSource(Dio dio) = _AuthDataSource;

  @POST('/api/v1/auth/email/login')
  Future<AuthModel> login(
    @Body() LoginBody body,
  );

  @POST('/api/v1/auth/email/register')
  Future<AuthModel> register(
    @Body() RegisterBody body,
  );

  @GET('/api/v1/me')
  Future<UserModel> getMe();

  @DELETE('/api/v1/me')
  Future<UserModel> deleteMe();

  @POST('/api/v1/auth/logout')
  Future<AuthModel> logout();
}
