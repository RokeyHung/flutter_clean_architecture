import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clean_architecture/core/config/app_config.dart';
import 'package:flutter_clean_architecture/framework/provider/app_config_provider.dart';
import 'package:flutter_clean_architecture/core/utils/async_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ua_client_hints/ua_client_hints.dart';
import 'package:flutter_clean_architecture/framework/provider/auth_provider.dart';

final dioProvider = Provider(
  (ref) => AppDio(
    ref: ref,
    baseUrl: ref.watch(appConfigProvider.select((value) => value.baseUrl)),
    appName: ref.watch(appConfigProvider.select((value) => value.appName)),
    appConfig: ref.watch(appConfigProvider),
  ),
);

class AppDio with DioMixin implements Dio {
  final User? user;
  final Ref ref;
  final AppConfig appConfig;
  Map<String, String>? userAgent;

  AppDio({
    this.user,
    required this.ref,
    required String baseUrl,
    required String appName,
    required this.appConfig,
    BaseOptions? options,
  }) {
    options = options ??
        BaseOptions(
          baseUrl: baseUrl,
          responseType: ResponseType.json,
          connectTimeout: Duration(milliseconds: appConfig.connectTimeout),
          sendTimeout: Duration(milliseconds: appConfig.connectTimeout),
          receiveTimeout: Duration(milliseconds: appConfig.receiveTimeout),
          headers: appConfig.defaultHeaders,
        );

    this.options = options;

    // Add interceptors
    _addInterceptors();

    httpClientAdapter = IOHttpClientAdapter();
  }

  void _addInterceptors() {
    // Auth interceptor
    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          dispatchMicroTask(() async {
            try {
              // Add user agent headers if not already set
              if (userAgent == null) {
                final uaData = await userAgentData();
                final clientHintsHeader = await userAgentClientHintsHeader();
                final ua = 'app App/${uaData.version} ('
                    '${uaData.platform} ${uaData.platformVersion};'
                    ' ${uaData.model};'
                    ' ${uaData.device};'
                    ' ${uaData.architecture})';
                final clientHintsUA = '"${uaData.package.packageName}";'
                    ' v="${uaData.version}"';
                clientHintsHeader['User-Agent'] = ua;
                clientHintsHeader['Sec-CH-UA'] = clientHintsUA;
                userAgent = clientHintsHeader;
              }

              // Merge user agent headers with existing headers
              options.headers.addAll(userAgent!);

              // Add authentication token
              final firebaseToken = await user?.getIdToken() ??
                  await FirebaseAuth.instance.currentUser?.getIdToken();

              if (firebaseToken != null) {
                options.headers['Authorization'] = 'Bearer $firebaseToken';
              } else {
                // Fallback to local auth token
                final localToken = ref.read(authProvider);
                if (localToken != null && localToken.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $localToken';
                }
              }
            } on Exception catch (e) {
              debugPrint('Error in auth interceptor: $e');
            }
            handler.next(options);
          });
        },
        onError: (error, handler) {
          // Handle 401 Unauthorized - clear local token
          if (error.response?.statusCode == 401) {
            ref.read(authProvider.notifier).clearToken();
            // You might want to navigate to login screen here
          }
          handler.next(error);
        },
      ),
    );

    // Logging interceptor
    if (appConfig.enableLogging) {
      interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) {
            if (appConfig.enableLogging) {
              debugPrint(obj.toString());
            }
          },
        ),
      );
    }

    // Error handling interceptor
    interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Add custom error handling logic here
          // For example, show toast messages, analytics tracking, etc.

          if (appConfig.enableLogging) {
            debugPrint('❌ API Error: ${error.message}');
            debugPrint('❌ Status Code: ${error.response?.statusCode}');
            debugPrint('❌ URL: ${error.requestOptions.path}');
          }

          handler.next(error);
        },
      ),
    );
  }
}
