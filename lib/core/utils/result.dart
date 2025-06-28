import 'package:flutter/material.dart';

import 'package:collection/collection.dart';

sealed class Result<T extends Object> {
  const Result._([this.value]);
  final T? value;

  T unwrap() => value!;

  T unwrapOr(T value) => this.value ?? value;

  T unwrapOrElse(UnwrapOrElseResultCallback<T> callback) =>
      value ?? callback(this as Err<T>);

  Result<T> or(Result<T> alt) => isOk() ? this : alt;

  Result<T> orElse(OrElseResultCallback<T> callback) =>
      isOk() ? this : callback(this as Err<T>);

  Result<U> map<U extends Object>({
    required MapOkCallback<T, U> ok,
    required MapErrCallback<T, U> err,
  });

  bool isOk() => value != null;

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other is Result && other.value == value);
  }

  @override
  int get hashCode => value?.hashCode ?? 0;
}

class Ok<T extends Object> extends Result<T> {
  const Ok(T value) : super._(value);

  @override
  Result<U> map<U extends Object>({
    required MapOkCallback<T, U> ok,
    required MapErrCallback<T, U> err,
  }) =>
      ok(this);

  @override
  String toString() => 'Ok($value)';
}

class Err<T extends Object> extends Result<T> {
  const Err(
    this.exception, {
    required this.stackTrace,
  }) : super._();

  final Exception exception;
  final StackTrace? stackTrace;

  @override
  T unwrap() {
    final stackTrace = this.stackTrace;
    if (stackTrace == null) {
      throw exception;
    }
    debugPrint('Err<$T> could not unwrap at ${StackTrace.current}');
    Error.throwWithStackTrace(exception, stackTrace);
  }

  @override
  Result<U> map<U extends Object>({
    required MapOkCallback<T, U> ok,
    required MapErrCallback<T, U> err,
  }) =>
      err(this);

  @override
  String toString() => 'Err($exception)';
}

extension ResultIteratorExt<T extends Object> on Iterable<Result<T>> {
  Result<Iterable<T>> intoResult() {
    final err = firstWhereOrNull((r) => r is Err);
    return (err as Err<Iterable<T>>?) ??
        Ok<Iterable<T>>(map((r) => r.unwrap()));
  }

  bool isOk() => !any((r) => r is Err);
}

typedef UnwrapOrElseResultCallback<T extends Object> = T Function(Err<T> err);
typedef OrElseResultCallback<T extends Object> = Result<T> Function(Err<T> err);
typedef MapOkCallback<T extends Object, U extends Object> = Result<U> Function(
  Ok<T> value,
);
typedef MapErrCallback<T extends Object, U extends Object> = Result<U> Function(
  Err<T> value,
);
