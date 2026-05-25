// TEST - mock_todo_repository.dart
import 'package:mocktail/mocktail.dart';
import 'package:flutter_clean_architecture/core/error/failures.dart';
import 'package:flutter_clean_architecture/domain/entities/todo_entity.dart';
import 'package:flutter_clean_architecture/domain/repositories/todo_repository.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

// Shared test fixtures
class TodoFixtures {
  static TodoEntity get todo1 =>
      const TodoEntity(id: 'uuid-1', title: 'Test Todo 1', completed: false);

  static TodoEntity get todo2 => const TodoEntity(
    id: 'uuid-2',
    title: 'Test Todo 2',
    completed: true,
    description: 'Some description',
  );

  static List<TodoEntity> get todoList => [todo1, todo2];

  static Failure get networkFailure =>
      const Failure.network(message: 'No internet');

  static Failure get serverFailure =>
      const Failure.server(message: 'Server error', statusCode: 500);
}
