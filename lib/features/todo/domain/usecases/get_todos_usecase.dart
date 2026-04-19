// DOMAIN USECASE - get_todos_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class GetTodosUseCase implements UseCase<List<TodoEntity>, NoParams> {
  final TodoRepository _repository;

  GetTodosUseCase(this._repository);

  @override
  Future<Either<Failure, List<TodoEntity>>> call(NoParams params) {
    return _repository.getTodos();
  }
}
