import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/provider/dio.dart';
import 'package:flutter_clean_architecture/data/data_sources/body/signup_body.dart';
import 'package:flutter_clean_architecture/data/model/user.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod/riverpod.dart';

part 'user_data_source.g.dart';

final userDataSourceProvider = Provider(
  (ref) => UserDataSource(
    ref.watch(dioProvider),
  ),
);

@RestApi()
abstract class UserDataSource {
  factory UserDataSource(Dio dio) => _UserDataSource(dio);

  @POST('/v1/login')
  Future<User> login();

  @POST('/v1/signup')
  Future<User> signup({
    @Body() SignUpBody? param,
  });

  @GET('/v1/users/{user_id}')
  Future<User> getUser({
    @Path('user_id') required int userId,
  });
}
