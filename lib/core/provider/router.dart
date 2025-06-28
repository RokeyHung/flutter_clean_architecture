import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/config/app_options.dart';
import 'package:flutter_clean_architecture/core/provider/app_options.dart';
import 'package:flutter_clean_architecture/core/route/app_route.gr.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<AppRouter>((ref) {
  final tabs = ref.watch(appOptionsProvider.select((options) => options.tabs));
  return CreatorRouter(
    timelineTab: tabs.firstWhereOrNull((tab) => tab.tab == AppTab.timeline) ??
        tabs.first,
  );
});

typedef NavigateFunction = Future<void> Function();

abstract class AppRouter {
  const AppRouter();

  PageRouteInfo<dynamic> tabToRoute(AppTab tab);
  Future<void> replaceAllHome(BuildContext context);
}

class CreatorRouter extends AppRouter {
  CreatorRouter({
    required this.timelineTab,
  });

  final AppTabType timelineTab;

  @override
  PageRouteInfo<dynamic> tabToRoute(AppTab tab) {
    switch (tab) {
      case AppTab.timeline:
        return const HomeRoute();
      default:
        return const HomeRoute();
    }
  }

  @override
  Future<void> replaceAllHome(BuildContext context) async {
    await context.router.replaceAll(const [HomeRoute()]);
    if (!context.mounted) {
      return;
    }
    await context.router.navigate(tabToRoute(timelineTab.tab));
  }
}
