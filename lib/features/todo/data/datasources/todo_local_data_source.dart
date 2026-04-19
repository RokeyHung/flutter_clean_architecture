// DATA SOURCE - todo_local_data_source.dart (SharedPreferences)
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/todo_model.dart';

abstract interface class TodoLocalDataSource {
  Future<List<TodoModel>> getCachedTodos();
  Future<void> cacheTodos(List<TodoModel> todos);
  Future<void> clearCache();
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences _prefs;

  TodoLocalDataSourceImpl(this._prefs);

  static const _cacheKey = 'cached_todos';

  @override
  Future<List<TodoModel>> getCachedTodos() async {
    final jsonString = _prefs.getString(_cacheKey);
    if (jsonString == null) {
      throw CacheException(message: 'No cached todos found');
    }
    final jsonList = json.decode(jsonString) as List;
    return jsonList
        .map((e) => TodoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> cacheTodos(List<TodoModel> todos) async {
    final jsonList = todos.map((t) => t.toJson()).toList();
    await _prefs.setString(_cacheKey, json.encode(jsonList));
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
  }
}
