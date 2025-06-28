import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard({required this.ref});

  final WidgetRef ref;

  @override
  void onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) {
    // TODO: Implement authentication logic
    resolver.next(true);
  }
}

class WelcomeGuard extends AutoRouteGuard {
  WelcomeGuard({required this.ref});

  final WidgetRef ref;

  @override
  void onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) {
    // TODO: Implement welcome logic
    resolver.next();
  }
}
