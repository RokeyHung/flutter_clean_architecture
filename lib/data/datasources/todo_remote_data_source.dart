// DATA SOURCE - todo_remote_data_source.dart
import 'package:dio/dio.dart';
import '../../core/error/exceptions.dart';
import '../models/todo_model.dart';

abstract interface class TodoRemoteDataSource {
  Future<List<TodoModel>> getTodos();
  Future<TodoModel> getTodoById(String id);
  Future<TodoModel> addTodo({required String title, String? description});
  Future<TodoModel> updateTodo(TodoModel todo);
  Future<void> deleteTodo(String id);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final Dio _dio;

  TodoRemoteDataSourceImpl(this._dio);

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      final response = await _dio.get(
        '/todos',
        queryParameters: {'_limit': 20},
      );
      return (response.data as List)
          .map((json) => TodoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<TodoModel> getTodoById(String id) async {
    try {
      final response = await _dio.get('/todos/$id');
      return TodoModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<TodoModel> addTodo({
    required String title,
    String? description,
  }) async {
    try {
      final response = await _dio.post(
        '/todos',
        data: {
          'title': title,
          'completed': false,
          'description': description,
          'userId': 1,
        },
      );
      return TodoModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<TodoModel> updateTodo(TodoModel todo) async {
    try {
      final response = await _dio.put('/todos/${todo.id}', data: todo.toJson());
      return TodoModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      await _dio.delete('/todos/$id');
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Exception _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException(message: 'Connection timeout: ${e.message}');
      case DioExceptionType.badResponse:
        return ServerException(
          message: e.response?.data?['message'] as String? ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection');
      default:
        return NetworkException(message: e.message ?? 'Network error');
    }
  }
}
