// DOMAIN - todo_repository.dart (interface)
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/todo_entity.dart';

abstract interface class TodoRepository {
  Future<Either<Failure, List<TodoEntity>>> getTodos();
  Future<Either<Failure, TodoEntity>> getTodoById(String id);
  Future<Either<Failure, TodoEntity>> addTodo({
    required String title,
    String? description,
  });
  Future<Either<Failure, TodoEntity>> updateTodo(TodoEntity todo);
  Future<Either<Failure, Unit>> deleteTodo(String id);
}
