import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exception.freezed.dart';
part 'network_exception.g.dart';

enum NetworkFailureType {
  /// It occurs when url is timeout.
  connectTimeout,

  ///
  sendTimeout,

  ///
  receiveTimeout,

  ///
  cancel,

  ///
  parseFailed,

  ///
  requestFailed,

  /// 許可されていない (e.g. 未ログイン)
  unauthorized,

  ///
  unknown,
}

@freezed
class AppServerError with _$AppServerError {
  const factory AppServerError.v1({
    required String code,
    required String developerMessage,
    required String message,
  }) = AppServerErrorV1;

  const factory AppServerError.empty({
    @Default('') String code,
    @Default('') String developerMessage,
    @Default('') String message,
  }) = AppServerErrorEmpty;

  factory AppServerError.fromJson(Map<String, dynamic> json) =>
      _$AppServerErrorFromJson(json);
}

class AppServerErrorConverter
    implements JsonConverter<AppServerError, Map<String, dynamic>> {
  const AppServerErrorConverter();

  @override
  AppServerError fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AppServerError.empty();
    }
    switch (json['version']) {
      case 1:
      case null:
        return AppServerErrorV1.fromJson(json);
      default:
        throw UnimplementedError();
    }
  }

  @override
  Map<String, dynamic> toJson(AppServerError data) => data.toJson();
}

class NetworkFailure implements Exception {
  NetworkFailure({
    this.type = NetworkFailureType.unknown,
    this.httpStatusCode = 0,
    this.error,
    this.response = const AppServerError.empty(),
  });

  NetworkFailure.fromDioException(DioException e)
      : response = converter.fromJson(e.response?.data),
        httpStatusCode = e.response?.statusCode ?? 0,
        error = e {
    type = estimateTypeFromDioException(e, response);
  }

  NetworkFailure.fromCheckedFromJsonException(CheckedFromJsonException e)
      : type = NetworkFailureType.parseFailed,
        httpStatusCode = 0,
        response = const AppServerError.empty(message: '通信に失敗しました。'),
        error = e;

  final int httpStatusCode;
  late final NetworkFailureType type;
  final dynamic error;
  final AppServerError response;

  String get message => response.message;

  @override
  String toString() =>
      'NetworkFailure(${type.name}, ${response.code}, "${response.developerMessage}")';

  static NetworkFailureType estimateTypeFromDioException(
    DioException e,
    AppServerError response,
  ) {
    switch (response.code) {
      case 'unauthorized':
      case 'unautorized':
        return NetworkFailureType.unauthorized;
      default:
        return e.type.toSessionErrorType();
    }
  }

  static const converter = AppServerErrorConverter();
}

class NetworkFailureConverter {
  static Exception fromError(dynamic error) {
    if (error is DioException) {
      return NetworkFailure.fromDioException(error);
    } else if (error is CheckedFromJsonException) {
      return NetworkFailure.fromCheckedFromJsonException(error);
    }
    return NetworkFailure(error: error);
  }
}

extension _DioExceptionTypeExtension on DioExceptionType {
  NetworkFailureType toSessionErrorType() {
    switch (this) {
      case DioExceptionType.cancel:
        return NetworkFailureType.cancel;

      case DioExceptionType.connectionTimeout:
        return NetworkFailureType.connectTimeout;

      case DioExceptionType.receiveTimeout:
        return NetworkFailureType.receiveTimeout;

      case DioExceptionType.sendTimeout:
        return NetworkFailureType.sendTimeout;

      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.connectionError:
        return NetworkFailureType.requestFailed;

      case DioExceptionType.unknown:
        return NetworkFailureType.unknown;
    }
  }
}
