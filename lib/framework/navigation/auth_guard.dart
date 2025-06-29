import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_clean_architecture/framework/navigation/app_route.gr.dart';
import 'package:flutter_clean_architecture/framework/provider/auth_provider.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard({required this.ref});

  final WidgetRef ref;

  @override
  void onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) {
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    
    if (isAuthenticated) {
      // User is authenticated, allow navigation
      resolver.next(true);
    } else {
      // User is not authenticated, redirect to login
      resolver.redirect(const LoginRoute());
    }
  }
}

class UnauthenticatedGuard extends AutoRouteGuard {
  UnauthenticatedGuard({required this.ref});

  final WidgetRef ref;

  @override
  void onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) {
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    
    if (isAuthenticated) {
      // User is already authenticated, redirect to home
      resolver.redirect(const HomeRoute());
    } else {
      // User is not authenticated, allow navigation to login/register screens
      resolver.next();
    }
  }
}
