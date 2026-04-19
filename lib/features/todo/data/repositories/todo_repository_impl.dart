// DATA - todo_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_data_source.dart';
import '../datasources/todo_remote_data_source.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource _remoteDataSource;
  final TodoLocalDataSource _localDataSource;
  static const _uuid = Uuid();

  TodoRepositoryImpl({
    required TodoRemoteDataSource remoteDataSource,
    required TodoLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodos() async {
    try {
      final remoteTodos = await _remoteDataSource.getTodos();
      await _localDataSource.cacheTodos(remoteTodos);
      return Right(remoteTodos.map((m) => m.toEntity()).toList());
    } on NetworkException catch (e) {
      // Fallback to cache on network error
      try {
        final cachedTodos = await _localDataSource.getCachedTodos();
        return Right(cachedTodos.map((m) => m.toEntity()).toList());
      } on CacheException {
        return Left(Failure.network(message: e.message));
      }
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> getTodoById(String id) async {
    try {
      final todo = await _remoteDataSource.getTodoById(id);
      return Right(todo.toEntity());
    } on NetworkException catch (e) {
      return Left(Failure.network(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> addTodo({
    required String title,
    String? description,
  }) async {
    try {
      final todo = await _remoteDataSource.addTodo(
        title: title,
        description: description,
      );
      // JSONPlaceholder returns id=201 always; we generate a real UUID for demo
      final withId = todo.copyWith(id: _uuid.v4());
      return Right(withId.toEntity());
    } on NetworkException catch (e) {
      return Left(Failure.network(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> updateTodo(TodoEntity todo) async {
    try {
      final updated = await _remoteDataSource.updateTodo(
        TodoModel.fromEntity(todo),
      );
      return Right(updated.toEntity());
    } on NetworkException catch (e) {
      return Left(Failure.network(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTodo(String id) async {
    try {
      await _remoteDataSource.deleteTodo(id);
      return const Right(unit);
    } on NetworkException catch (e) {
      return Left(Failure.network(message: e.message));
    } on ServerException catch (e) {
      return Left(Failure.server(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString()));
    }
  }
}
