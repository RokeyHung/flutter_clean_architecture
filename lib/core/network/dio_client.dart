// CORE - dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        // ignore: avoid_print
        logPrint: (obj) => print(obj),
      ),
    ]);

    return dio;
  }
}
