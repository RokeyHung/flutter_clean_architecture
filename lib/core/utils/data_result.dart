import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Represents a failure due to a violated business rule (e.g. terms not accepted, invalid password match, etc.)
class ResultFailure implements Exception {
  final String message;
  const ResultFailure(this.message);

  @override
  String toString() => message;
}

/// Common system-level failure types
class GenericFailure implements Exception {}

class APIFailure implements Exception {}

class LocalStorageFailure implements Exception {}

class LoggedOutFailure implements Exception {}

class LoadLocalDataSourceFailure implements Exception {}

class LoadSecureLocalDataSourceFailure implements Exception {}

class PhotoAccessDeniedFailure implements Exception {}

class DuplicatedFailure implements Exception {}

class NotFoundFailure implements Exception {}

/// Represents a result that can either be a success or a failure.
/// Commonly used in UseCases to decouple business rules from infrastructure logic.
sealed class DataResult<S> extends Equatable {
  const DataResult._();

  static DataResult<S> success<S>(S data) => Success(data);

  static DataResult<S> failure<S>(
    Exception failure, [
    StackTrace? stackTrace,
  ]) =>
      Failure(failure, stackTrace);

  /// Returns the error value if present, otherwise null
  Exception? get error => fold((e) => e, (_) => null);

  /// Returns the data value if present, otherwise null
  S? get data => fold((_) => null, (d) => d);

  /// Whether the result represents a success
  bool get isSuccess => this is Success<S>;

  /// Whether the result represents a failure
  bool get isFailure => this is Failure<S>;

  /// Returns `data` if success, otherwise returns `other`
  S dataOrElse(S other) => isSuccess && data != null ? data! : other;

  /// Sugar for `dataOrElse`
  S operator |(S other) => dataOrElse(other);

  /// Transforms either the error or the data into a new result
  DataResult<T> either<T>(
    Exception Function(Exception error) fnFailure,
    T Function(S data) fnData,
  );

  /// If success, transforms the data and returns a new result (which could be success or failure)
  DataResult<T> then<T>(
    DataResult<T> Function(S data) fnData,
  );

  /// Maps the success data while preserving the original result type
  DataResult<T> map<T>(
    T Function(S data) fnData,
  );

  /// Folds the result into a single value
  T fold<T>(
    T Function(Exception error) fnFailure,
    T Function(S data) fnData,
  );

  /// Returns a new `Success` with new data, or returns self if failure
  DataResult<S> replaceData(S newData) => isSuccess ? Success(newData) : this;

  /// Handles both branches like `freezed.when`
  T when<T>({
    required T Function(S data) success,
    required T Function(Exception error, StackTrace? stackTrace) failure,
  }) {
    if (this is Success<S>) {
      return success((this as Success<S>).value);
    } else if (this is Failure<S>) {
      final fail = this as Failure<S>;
      return failure(fail.value, fail.stackTrace);
    }
    throw UnimplementedError();
  }

  /// Async version of `when`
  Future<T> whenAsync<T>({
    required Future<T> Function(S data) success,
    required Future<T> Function(Exception error, StackTrace? stackTrace)
        failure,
  }) async {
    if (this is Success<S>) {
      return success((this as Success<S>).value);
    } else if (this is Failure<S>) {
      final fail = this as Failure<S>;
      return failure(fail.value, fail.stackTrace);
    }
    throw UnimplementedError();
  }

  /// Retries `fn` up to [count] times if it fails, with delay between attempts
  static Future<DataResult<S>> retry<S>(
    FutureOr<DataResult<S>> Function() fn, {
    int count = 3,
    Duration interval = const Duration(milliseconds: 250),
  }) async {
    assert(count > 0);

    var result = await fn();
    for (var i = 1; i < count; i++) {
      if (result.isSuccess) break;
      await Future.delayed(interval);
      result = await fn();
    }
    return result;
  }

  @override
  List<Object?> get props => [isSuccess ? data : error];
}

/// Holds the success branch of a DataResult
class Success<S> extends DataResult<S> {
  final S value;

  const Success(this.value) : super._();

  @override
  Success<T> either<T>(
    Exception Function(Exception error) fnFailure,
    T Function(S data) fnData,
  ) =>
      Success<T>(fnData(value));

  @override
  DataResult<T> then<T>(DataResult<T> Function(S data) fnData) => fnData(value);

  @override
  Success<T> map<T>(T Function(S data) fnData) => Success<T>(fnData(value));

  @override
  T fold<T>(
    T Function(Exception error) fnFailure,
    T Function(S data) fnData,
  ) =>
      fnData(value);
}

/// Holds the failure branch of a DataResult
class Failure<S> extends DataResult<S> {
  final Exception value;
  final StackTrace? stackTrace;

  Failure(this.value, [this.stackTrace]) : super._() {
    if (kDebugMode) {
      debugPrint(
        '********** DataResult Failure **********\n'
        'Exception: $value\n'
        'StackTrace: ${stackTrace ?? StackTrace.current}\n'
        '****************************************',
      );
    }

    FirebaseCrashlytics.instance.recordError(
      value,
      stackTrace ?? StackTrace.current,
    );
  }

  @override
  Failure<T> either<T>(
    Exception Function(Exception error) fnFailure,
    T Function(S data) fnData,
  ) =>
      Failure<T>(fnFailure(value), stackTrace);

  @override
  Failure<T> map<T>(T Function(S data) fnData) => Failure<T>(value, stackTrace);

  @override
  Failure<T> then<T>(DataResult<T> Function(S data) fnData) =>
      Failure<T>(value, stackTrace);

  @override
  T fold<T>(
    T Function(Exception error) fnFailure,
    T Function(S data) fnData,
  ) =>
      fnFailure(value);
}
