// TEST - add_todo_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/domain/usecases/add_todo_usecase.dart';
import '../../helpers/mock_todo_repository.dart';

void main() {
  late AddTodoUseCase useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = AddTodoUseCase(mockRepository);
  });

  group('AddTodoUseCase', () {
    const tTitle = 'New Todo';
    const tDescription = 'Some description';
    const tParams = AddTodoParams(title: tTitle, description: tDescription);
    const tParamsNoDesc = AddTodoParams(title: tTitle);

    test('should add todo with title and description', () async {
      // arrange
      const newTodo = TodoEntity(
        id: 'uuid-new',
        title: tTitle,
        completed: false,
        description: tDescription,
      );
      when(
        () => mockRepository.addTodo(title: tTitle, description: tDescription),
      ).thenAnswer((_) async => const Right(newTodo));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, isA<Right>());
      result.fold((_) => fail('Expected Right'), (todo) {
        expect(todo.title, tTitle);
        expect(todo.description, tDescription);
        expect(todo.completed, false);
      });
      verify(
        () => mockRepository.addTodo(title: tTitle, description: tDescription),
      ).called(1);
    });

    test('should add todo without description', () async {
      // arrange
      const newTodo = TodoEntity(
        id: 'uuid-new',
        title: tTitle,
        completed: false,
      );
      when(
        () => mockRepository.addTodo(title: tTitle, description: null),
      ).thenAnswer((_) async => const Right(newTodo));

      // act
      final result = await useCase(tParamsNoDesc);

      // assert
      result.fold((_) => fail('Expected Right'), (todo) {
        expect(todo.title, tTitle);
        expect(todo.description, isNull);
      });
    });

    test('should return failure when repository fails', () async {
      // arrange
      when(
        () => mockRepository.addTodo(
          title: any(named: 'title'),
          description: any(named: 'description'),
        ),
      ).thenAnswer(
        (_) async => const Left(Failure.network(message: 'No internet')),
      );

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, isA<Left>());
      result.fold(
        (failure) =>
            expect(failure, const Failure.network(message: 'No internet')),
        (_) => fail('Expected Left'),
      );
    });
  });
}
