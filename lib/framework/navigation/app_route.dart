import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/framework/navigation/app_route.gr.dart';
import 'package:flutter_clean_architecture/framework/navigation/auth_guard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@AutoRouterConfig(generateForDir: ['lib/presentation'])
class AppRouter extends RootStackRouter {
  AppRouter({this.ref});

  final WidgetRef? ref;

  @override
  List<AutoRoute> get routes => [
        // Startup screen - initial route
        AutoRoute(
          path: '/',
          page: StartupRoute.page,
        ),
        
        // Auth routes (protected by UnauthenticatedGuard)
        AutoRoute(
          path: '/login',
          page: LoginRoute.page,
          guards: [UnauthenticatedGuard(ref: ref!)],
        ),
        AutoRoute(
          path: '/register',
          page: RegisterRoute.page,
          guards: [UnauthenticatedGuard(ref: ref!)],
        ),
        
        // Home route (protected by AuthGuard)
        AutoRoute(
          path: '/home',
          page: HomeRoute.page,
          guards: [AuthGuard(ref: ref!)],
          children: [
            AutoRoute(
              path: 'timeline',
              page: TimelineRoute.page,
            ),
          ],
        ),
        
        // Timeline route (protected by AuthGuard)
        AutoRoute(
          path: '/timeline',
          page: TimelineRoute.page,
          guards: [AuthGuard(ref: ref!)],
        ),
      ];
}

Route<T> modalSheetBuilder<T>(
  BuildContext context,
  Widget child,
  AutoRoutePage<T> page,
) {
  return ModalBottomSheetRoute(
    settings: page,
    builder: (context) {
      return child;
    },
    enableDrag: true,
    isScrollControlled: true,
  );
}

CustomRouteBuilder createModalBottomSheetBuilder({
  required bool isScrollControlled,
  bool enableDrag = true,
  bool expanded = false,
  bool isDismissible = true,
}) {
  Route<T> buildModalBottomSheet<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) {
    return ModalBottomSheetRoute(
      settings: page,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return child;
      },
    );
  }

  return buildModalBottomSheet;
}
