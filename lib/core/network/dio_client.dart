// CORE - dio_client.dart
import 'package:dio/dio.dart';
import '../config/app_config.dart';

class DioClient {
  static Dio createDio(AppConfig config) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    if (config.enableApiLogging) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          // ignore: avoid_print
          logPrint: (obj) => print(obj),
        ),
      );
    }

    return dio;
  }
}
