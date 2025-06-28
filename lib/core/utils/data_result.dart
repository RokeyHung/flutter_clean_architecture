// The code below was inspired by my swift implementation https://gist.github.com/CassiusPacheco/4378d30d69316e4a6ba28a0c3af72628
// and Avdosev's Dart Either https://github.com/avdosev/either_dart/blob/master/lib/src/either.dart

import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';

// General failures
class GenericFailure implements Exception {}

class APIFailure implements Exception {}

class LocalStorageFailure implements Exception {}

class LoggedOutFailure implements Exception {}

class LoadLocalDataSourceFailure implements Exception {}

class LoadSecureLocalDataSourceFailure implements Exception {}

class PhotoAccessDeniedFailure implements Exception {}

class DuplicatedFailure implements Exception {}

class NotFoundFailure implements Exception {}

/// This abstraction contains either a success data of generic type `S` or a
/// failure error of type `Failure` as its result.
///
/// `data` property must only be retrieved when `DataResult` was constructed by
/// using `DataResult.success(value)`. It can be validated by calling
/// `isSuccess` first. Alternatively, `dataOrElse` can be used instead since it
/// ensures a valid value is returned in case the result is a failure.
///
/// `error` must only be retrieved when `DataResult` was constructed by using
/// `DataResult.failure(error)`. It can be validated by calling `isFailure`
/// first.
sealed class DataResult<S> extends Equatable {
  static DataResult<S> failure<S>(Exception failure,
          [StackTrace? stackTrace]) =>
      Failure(failure, stackTrace);
  static DataResult<S> success<S>(S data) => Success(data);

  const DataResult._();

  /// Get [error] value, returns null when the value is actually [data]
  Exception? get error => fold<Exception?>((error) => error, (data) => null);

  /// Get [data] value, returns null when the value is actually [error]
  S? get data => fold<S?>((error) => null, (data) => data);

  /// Returns `true` if the object is of the `SuccessResult` type, which means
  /// `data` will return a valid result.
  bool get isSuccess => this is Success<S>;

  /// Returns `true` if the object is of the `FailureResult` type, which means
  /// `error` will return a valid result.
  bool get isFailure => this is Failure<S>;

  /// Returns `data` if `isSuccess` returns `true`, otherwise it returns
  /// `other`.
  S dataOrElse(S other) => isSuccess && data != null ? data! : other;

  /// Sugar syntax that calls `dataOrElse` under the hood. Returns left value if
  /// `isSuccess` returns `true`, otherwise it returns the right value.
  S operator |(S other) => dataOrElse(other);

  /// Transforms values of [error] and [data] in new a `DataResult` type. Only
  /// the matching function to the object type will be executed. For example,
  /// for a `SuccessResult` object only the [fnData] function will be executed.
  DataResult<T> either<T>(
      Exception Function(Exception error) fnFailure, T Function(S data) fnData);

  /// Transforms value of [data] allowing a new `DataResult` to be returned.
  /// A `SuccessResult` might return a `FailureResult` and vice versa.
  DataResult<T> then<T>(DataResult<T> Function(S data) fnData);

  /// Transforms value of [data] always keeping the original identity of the
  /// `DataResult`, meaning that a `SuccessResult` returns a `SuccessResult` and
  /// a `FailureResult` always returns a `FailureResult`.
  DataResult<T> map<T>(T Function(S data) fnData);

  /// Folds [error] and [data] into the value of one type. Only the matching
  /// function to the object type will be executed. For example, for a
  /// `SuccessResult` object only the [fnData] function will be executed.
  T fold<T>(T Function(Exception error) fnFailure, T Function(S data) fnData);

  static Future<DataResult<S>> retry<S>(
    FutureOr<DataResult<S>> Function() fn, {
    int count = 3,
    Duration interval = const Duration(milliseconds: 250),
  }) async {
    assert(count > 0);

    var result = await fn();
    for (var i = 1; i < count; i++) {
      if (result.isSuccess) {
        break;
      }
      await Future.delayed(interval);
      result = await fn();
    }
    return result;
  }

  @override
  List<Object?> get props => [if (isSuccess) data else error];
}

/// Success implementation of `DataResult`. It contains `data`. It's abstracted
/// away by `DataResult`. It shouldn't be used directly in the app.
class Success<S> extends DataResult<S> {
  final S value;

  const Success(this.value) : super._();

  @override
  Success<T> either<T>(Exception Function(Exception error) fnFailure,
      T Function(S data) fnData) {
    return Success<T>(fnData(value));
  }

  @override
  DataResult<T> then<T>(DataResult<T> Function(S data) fnData) {
    return fnData(value);
  }

  @override
  Success<T> map<T>(T Function(S data) fnData) {
    return Success<T>(fnData(value));
  }

  @override
  T fold<T>(T Function(Exception error) fnFailure, T Function(S data) fnData) {
    return fnData(value);
  }
}

/// Exception implementation of `DataResult`. It contains `error`.  It's
/// abstracted away by `DataResult`. It shouldn't be used directly in the app.
class Failure<S> extends DataResult<S> {
  final Exception value;

  Failure(this.value, [StackTrace? stackTrace]) : super._() {
    if (kDebugMode) {
      debugPrint(
        '****************************************\n'
        'DataResult($value) occurred at\n'
        '${stackTrace ?? StackTrace.current}'
        '****************************************',
      );
    }
    FirebaseCrashlytics.instance.recordError(
      value,
      stackTrace ?? StackTrace.current,
    );
  }

  @override
  Failure<T> either<T>(Exception Function(Exception error) fnFailure,
      T Function(S data) fnData) {
    return Failure<T>(fnFailure(value));
  }

  @override
  Failure<T> map<T>(T Function(S data) fnData) {
    return Failure<T>(value);
  }

  @override
  Failure<T> then<T>(DataResult<T> Function(S data) fnData) {
    return Failure<T>(value);
  }

  @override
  T fold<T>(T Function(Exception error) fnFailure, T Function(S data) fnData) {
    return fnFailure(value);
  }
}
