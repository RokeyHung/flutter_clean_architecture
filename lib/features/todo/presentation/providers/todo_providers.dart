// PRESENTATION - todo_providers.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/app_config_provider.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/todo_local_data_source.dart';
import '../../data/datasources/todo_remote_data_source.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../state/todo_state.dart';
import 'todo_notifier.dart';

// ── Network ───────────────────────────────────────────────────────────────────

final dioProvider = Provider<Dio>(
  (ref) => DioClient.createDio(ref.watch(appConfigProvider)),
);

// ── Data Sources ──────────────────────────────────────────────────────────────

final todoRemoteDataSourceProvider = Provider<TodoRemoteDataSource>((ref) {
  return TodoRemoteDataSourceImpl(ref.watch(dioProvider));
});

final todoLocalDataSourceProvider = Provider<TodoLocalDataSource>((ref) {
  return TodoLocalDataSourceImpl(ref.watch(sharedPreferencesProvider));
});

// ── Repository ────────────────────────────────────────────────────────────────

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(
    remoteDataSource: ref.watch(todoRemoteDataSourceProvider),
    localDataSource: ref.watch(todoLocalDataSourceProvider),
  );
});

// ── Use Cases ─────────────────────────────────────────────────────────────────

final getTodosUseCaseProvider = Provider<GetTodosUseCase>((ref) {
  return GetTodosUseCase(ref.watch(todoRepositoryProvider));
});

final addTodoUseCaseProvider = Provider<AddTodoUseCase>((ref) {
  return AddTodoUseCase(ref.watch(todoRepositoryProvider));
});

// ── Notifier (Riverpod 3 — NotifierProvider) ─────────────────────────────────

final todoNotifierProvider = NotifierProvider<TodoNotifier, TodoState>(
  TodoNotifier.new,
);
