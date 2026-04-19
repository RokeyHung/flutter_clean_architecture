// DATA - todo_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/todo_entity.dart';

part 'todo_model.freezed.dart';
part 'todo_model.g.dart';

@freezed
abstract class TodoModel with _$TodoModel {
  const TodoModel._();

  const factory TodoModel({
    required String id,
    required String title,
    @Default(false) bool completed,
    String? description,
  }) = _TodoModel;

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  TodoEntity toEntity() => TodoEntity(
    id: id,
    title: title,
    completed: completed,
    description: description,
  );

  factory TodoModel.fromEntity(TodoEntity entity) => TodoModel(
    id: entity.id,
    title: entity.title,
    completed: entity.completed,
    description: entity.description,
  );
}
