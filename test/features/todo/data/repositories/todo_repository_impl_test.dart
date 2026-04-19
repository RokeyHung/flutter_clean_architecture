// TEST - todo_repository_impl_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_clean_architecture/core/error/exceptions.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/features/todo/data/datasources/todo_local_data_source.dart';
import 'package:flutter_clean_architecture/features/todo/data/datasources/todo_remote_data_source.dart';
import 'package:flutter_clean_architecture/features/todo/data/models/todo_model.dart';
import 'package:flutter_clean_architecture/features/todo/data/repositories/todo_repository_impl.dart';

class MockRemoteDataSource extends Mock implements TodoRemoteDataSource {}

class MockLocalDataSource extends Mock implements TodoLocalDataSource {}

void main() {
  late TodoRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;

  const tModel = TodoModel(id: 'uuid-1', title: 'Test', completed: false);
  final tModelList = [tModel];

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = TodoRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('getTodos', () {
    test(
      'returns list of entities on remote success and caches them',
      () async {
        when(() => mockRemote.getTodos()).thenAnswer((_) async => tModelList);
        when(() => mockLocal.cacheTodos(any())).thenAnswer((_) async {});

        final result = await repository.getTodos();

        expect(result, isA<Right>());
        result.fold((_) => fail('Expected Right'), (todos) {
          expect(todos.length, 1);
          expect(todos.first.title, 'Test');
        });
        verify(() => mockLocal.cacheTodos(tModelList)).called(1);
      },
    );

    test('returns cached data when network error occurs', () async {
      when(
        () => mockRemote.getTodos(),
      ).thenThrow(NetworkException(message: 'No internet'));
      when(
        () => mockLocal.getCachedTodos(),
      ).thenAnswer((_) async => tModelList);

      final result = await repository.getTodos();

      expect(result, isA<Right>());
    });

    test('returns NetworkFailure when both remote and cache fail', () async {
      when(
        () => mockRemote.getTodos(),
      ).thenThrow(NetworkException(message: 'No internet'));
      when(
        () => mockLocal.getCachedTodos(),
      ).thenThrow(CacheException(message: 'No cache'));

      final result = await repository.getTodos();

      expect(result, isA<Left>());
      result.fold(
        (failure) => failure.maybeWhen(
          network: (msg, _) => expect(msg, 'No internet'),
          orElse: () => fail('Expected NetworkFailure'),
        ),
        (_) => fail('Expected Left'),
      );
    });

    test('returns ServerFailure on server exception', () async {
      when(
        () => mockRemote.getTodos(),
      ).thenThrow(ServerException(message: 'Server error', statusCode: 500));

      final result = await repository.getTodos();

      expect(result, isA<Left>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('addTodo', () {
    test('returns new entity on success', () async {
      when(
        () => mockRemote.addTodo(
          title: any(named: 'title'),
          description: any(named: 'description'),
        ),
      ).thenAnswer((_) async => tModel);

      final result = await repository.addTodo(title: 'Test');

      expect(result, isA<Right>());
    });

    test(
      'returns NetworkFailure when remote throws NetworkException',
      () async {
        when(
          () => mockRemote.addTodo(
            title: any(named: 'title'),
            description: any(named: 'description'),
          ),
        ).thenThrow(NetworkException(message: 'No internet'));

        final result = await repository.addTodo(title: 'Test');

        expect(result, isA<Left>());
        result.fold(
          (f) => expect(f, isA<NetworkFailure>()),
          (_) => fail('Expected Left'),
        );
      },
    );
  });
}
