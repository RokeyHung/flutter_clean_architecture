import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_clean_architecture/framework/provider/app_config_provider.dart';
import 'package:flutter_clean_architecture/core/utils/async_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

final dioProvider = Provider(
  (ref) => AppDio(
    baseUrl: ref.watch(appConfigProvider.select((value) => value.baseUrl)),
    appName: ref.watch(appConfigProvider.select((value) => value.appName)),
  ),
);

class AppDio with DioMixin implements Dio {
  final User? user;

  Map<String, String>? userAgent;

  AppDio({
    this.user,
    required String baseUrl,
    required String appName,
    BaseOptions? options,
  }) {
    options = options ??
        BaseOptions(
          baseUrl: baseUrl,
          responseType: ResponseType.json,
          connectTimeout: const Duration(seconds: 40),
          sendTimeout: const Duration(seconds: 40),
          receiveTimeout: const Duration(seconds: 40),
        );

    this.options = options;

    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          dispatchMicroTask(() async {
            try {
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
              options.headers.addAll(userAgent!);

              final token = await user?.getIdToken() ??
                  await FirebaseAuth.instance.currentUser?.getIdToken();

              if (token != null) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            } on Exception catch (e) {
              debugPrint('$e');
            }
            handler.next(options);
          });
        },
      ),
    );

    if (kDebugMode) {
      interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    }

    httpClientAdapter = IOHttpClientAdapter();
  }
}
