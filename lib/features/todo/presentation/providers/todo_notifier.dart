// PRESENTATION - todo_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../state/todo_state.dart';
import 'todo_providers.dart';

class TodoNotifier extends Notifier<TodoState> {
  @override
  TodoState build() => const TodoState.initial();

  Future<void> loadTodos() async {
    state = const TodoState.loading();
    final result = await ref.read(getTodosUseCaseProvider)(const NoParams());
    result.fold(
      (failure) => state = TodoState.error(_failureMessage(failure)),
      (todos) => state = TodoState.loaded(todos),
    );
  }

  Future<void> addTodo(String title, {String? description}) async {
    final currentTodos = switch (state) {
      TodoLoaded(:final todos) => todos,
      _ => <TodoEntity>[],
    };

    final result = await ref.read(addTodoUseCaseProvider)(
      AddTodoParams(title: title, description: description),
    );

    result.fold(
      (failure) => state = TodoState.error(_failureMessage(failure)),
      (newTodo) => state = TodoState.loaded([...currentTodos, newTodo]),
    );
  }

  String _failureMessage(Failure failure) => switch (failure) {
    NetworkFailure(:final message) => 'Network error: $message',
    ServerFailure(:final message) => 'Server error: $message',
    CacheFailure(:final message) => 'Cache error: $message',
    UnknownFailure(:final message) => 'Unknown error: $message',
  };
}
