// DOMAIN - todo_entity.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_entity.freezed.dart';

@freezed
sealed class TodoEntity with _$TodoEntity {
  const factory TodoEntity({
    required String id,
    required String title,
    required bool completed,
    String? description,
  }) = _TodoEntity;
}
