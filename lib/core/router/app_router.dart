// CORE - app_router.dart (auto_route)
import 'package:auto_route/auto_route.dart';
import '../../features/todo/presentation/pages/add_todo_page.dart';
import '../../features/todo/presentation/pages/todo_list_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: TodoListRoute.page, initial: true),
    AutoRoute(page: AddTodoRoute.page),
  ];
}
