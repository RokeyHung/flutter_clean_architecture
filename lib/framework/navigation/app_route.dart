import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/framework/navigation/app_route.gr.dart';

@AutoRouterConfig(generateForDir: ['lib/presentation'])
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
          children: [
            AutoRoute(
              path: 'timeline',
              page: TimelineRoute.page,
            ),
          ],
        ),
        AutoRoute(
          path: '/timeline',
          page: TimelineRoute.page,
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
