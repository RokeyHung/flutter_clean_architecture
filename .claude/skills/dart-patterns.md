# skill: dart-patterns

# Các Dart 3 / Flutter patterns thường dùng trong project này

## Sealed class switch (Freezed v3)

```dart
// State
switch (state) {
  TodoInitial() => const Center(child: Text('Pull to refresh')),
  TodoLoading() => const CircularProgressIndicator(),
  TodoLoaded(:final todos) => TodoListView(todos: todos),
  TodoError(:final message) => ErrorView(message: message),
}

// Failure
switch (failure) {
  NetworkFailure(:final message) => 'Mạng: $message',
  ServerFailure(:final message, :final statusCode) => 'Server $statusCode: $message',
  CacheFailure(:final message) => 'Cache: $message',
  UnknownFailure(:final message) => 'Lỗi: $message',
}
```

## Either fold

```dart
final result = await useCase(params);
result.fold(
  (failure) => state = XState.error(_failureMessage(failure)),
  (data)    => state = XState.loaded(data),
);
```

## Notifier (Riverpod 3)

```dart
class XNotifier extends Notifier<XState> {
  @override
  XState build() => const XState.initial();

  Future<void> load() async {
    state = const XState.loading();
    final result = await ref.read(xUseCaseProvider)(const NoParams());
    result.fold(
      (f) => state = XState.error(_msg(f)),
      (d) => state = XState.loaded(d),
    );
  }
}

final xProvider = NotifierProvider<XNotifier, XState>(XNotifier.new);
```

## Freezed sealed class

```dart
@freezed
sealed class XState with _$XState {
  const factory XState.initial()              = XInitial;
  const factory XState.loading()              = XLoading;
  const factory XState.loaded(List<X> items)  = XLoaded;
  const factory XState.error(String message)  = XError;
}
```

## Freezed abstract class (single variant + custom methods)

```dart
@freezed
abstract class XModel with _$XModel {
  const XModel._();
  const factory XModel({ required String id, required String name }) = _XModel;
  factory XModel.fromJson(Map<String, dynamic> json) => _$XModelFromJson(json);
  XEntity toEntity() => XEntity(id: id, name: name);
}
```

## Repository impl pattern

```dart
@override
Future<Either<Failure, List<XEntity>>> getAll() async {
  try {
    final data = await _remote.getAll();
    await _local.cache(data);
    return Right(data.map((m) => m.toEntity()).toList());
  } on NetworkException catch (e) {
    try {
      final cached = await _local.getCached();
      return Right(cached.map((m) => m.toEntity()).toList());
    } on CacheException {
      return Left(Failure.network(message: e.message));
    }
  } on ServerException catch (e) {
    return Left(Failure.server(message: e.message, statusCode: e.statusCode));
  } catch (e) {
    return Left(Failure.unknown(message: e.toString()));
  }
}
```

## DataSource pattern (không dùng Never)

```dart
@override
Future<List<XModel>> getAll() async {
  try {
    final response = await _dio.get('/xs');
    return (response.data as List)
        .map((j) => XModel.fromJson(j as Map<String, dynamic>))
        .toList();
  } on DioException catch (e) {
    throw _mapDioError(e);
  }
}

Exception _mapDioError(DioException e) => switch (e.type) {
  DioExceptionType.connectionTimeout ||
  DioExceptionType.receiveTimeout    ||
  DioExceptionType.sendTimeout       => NetworkException(message: 'Timeout'),
  DioExceptionType.badResponse       => ServerException(
      message: e.response?.data?['message'] as String? ?? 'Server error',
      statusCode: e.response?.statusCode,
    ),
  DioExceptionType.connectionError   => NetworkException(message: 'No internet'),
  _                                  => NetworkException(message: e.message ?? 'Network error'),
};
```

## Auto Route navigation

```dart
// Push
context.pushRoute(const DetailRoute(id: '123'));

// Pop
context.maybePop();

// Replace
context.replaceRoute(const HomeRoute());
```
