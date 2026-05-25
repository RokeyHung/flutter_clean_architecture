// PRESENTATION - todo_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entities/todo_entity.dart';

part 'todo_state.freezed.dart';

@freezed
sealed class TodoState with _$TodoState {
  const factory TodoState.initial() = TodoInitial;
  const factory TodoState.loading() = TodoLoading;
  const factory TodoState.loaded(List<TodoEntity> todos) = TodoLoaded;
  const factory TodoState.error(String message) = TodoError;
}
