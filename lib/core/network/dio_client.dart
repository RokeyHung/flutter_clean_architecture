// CORE - dio_client.dart
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../utils/app_logger.dart';

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
      dio.interceptors.add(_AppLoggerInterceptor());
    }

    return dio;
  }
}

/// Interceptor dùng AppLogger thay vì print() thô.
class _AppLoggerInterceptor extends Interceptor {
  static const _tag = 'Dio';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d('→ ${options.method} ${options.uri}', tag: _tag);
    if (options.data != null) {
      AppLogger.d('  body: ${options.data}', tag: _tag);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.d(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      tag: _tag,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      '✗ ${err.requestOptions.method} ${err.requestOptions.uri} '
      '[${err.response?.statusCode}] ${err.message}',
      tag: _tag,
      error: err,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }
}
