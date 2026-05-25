// DOMAIN USECASE - add_todo_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class AddTodoParams {
  final String title;
  final String? description;

  const AddTodoParams({required this.title, this.description});
}

class AddTodoUseCase implements UseCase<TodoEntity, AddTodoParams> {
  final TodoRepository _repository;

  AddTodoUseCase(this._repository);

  @override
  Future<Either<Failure, TodoEntity>> call(AddTodoParams params) {
    return _repository.addTodo(
      title: params.title,
      description: params.description,
    );
  }
}
