// TEST - get_todos_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/core/usecase/usecase.dart';
import 'package:flutter_clean_architecture/domain/usecases/get_todos_usecase.dart';
import '../../helpers/mock_todo_repository.dart';

void main() {
  late GetTodosUseCase useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = GetTodosUseCase(mockRepository);
  });

  group('GetTodosUseCase', () {
    test('should return list of todos when repository call succeeds', () async {
      // arrange
      when(
        () => mockRepository.getTodos(),
      ).thenAnswer((_) async => Right(TodoFixtures.todoList));

      // act
      final result = await useCase(const NoParams());

      // assert
      expect(result, isA<Right>());
      result.fold((failure) => fail('Expected Right but got Left'), (todos) {
        expect(todos.length, 2);
        expect(todos.first.title, 'Test Todo 1');
        expect(todos.first.completed, false);
        expect(todos[1].completed, true);
      });
      verify(() => mockRepository.getTodos()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return network failure when repository returns network error',
      () async {
        // arrange
        when(
          () => mockRepository.getTodos(),
        ).thenAnswer((_) async => Left(TodoFixtures.networkFailure));

        // act
        final result = await useCase(const NoParams());

        // assert
        expect(result, isA<Left>());
        result.fold((failure) {
          expect(failure, isA<NetworkFailure>());
          expect((failure as NetworkFailure).message, 'No internet');
        }, (_) => fail('Expected Left but got Right'));
      },
    );

    test(
      'should return server failure when repository returns server error',
      () async {
        // arrange
        when(
          () => mockRepository.getTodos(),
        ).thenAnswer((_) async => Left(TodoFixtures.serverFailure));

        // act
        final result = await useCase(const NoParams());

        // assert
        expect(result, isA<Left>());
        result.fold((failure) {
          expect(failure, isA<ServerFailure>());
          final sf = failure as ServerFailure;
          expect(sf.message, 'Server error');
          expect(sf.statusCode, 500);
        }, (_) => fail('Expected Left but got Right'));
      },
    );

    test(
      'should return empty list when repository returns empty todos',
      () async {
        // arrange
        when(
          () => mockRepository.getTodos(),
        ).thenAnswer((_) async => const Right([]));

        // act
        final result = await useCase(const NoParams());

        // assert
        result.fold(
          (_) => fail('Expected Right'),
          (todos) => expect(todos, isEmpty),
        );
      },
    );
  });
}
