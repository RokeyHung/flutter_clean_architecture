import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/framework/provider/dio_provider.dart';
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
}
