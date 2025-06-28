import 'package:auto_route/auto_route.dart';
import 'package:creator/core/config/oem_options.dart';
import 'package:creator/core/provider/oem_options.dart';
import 'package:creator/core/route/app_route.gr.dart';
import 'package:creator/domain/gateway/auth_repository.dart';
import 'package:creator/domain/gateway/firebase_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard({required this.ref});

  final WidgetRef ref;

  @override
  void onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) {
    final authRepository = ref.read(authRepositoryProvider);
    final firebaseAuthRepository = ref.read(firebaseAuthRepositoryProvider);

    if (authRepository.currentAuthData != null &&
        firebaseAuthRepository.user != null) {
      resolver.next(true);
    } else {
      resolver.redirect(WelcomeRoute());
    }
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
    final oemOptions = ref.read(oemOptionsProvider);
    final authRepository = ref.read(authRepositoryProvider);
    if (!authRepository.authorized) {
      switch (oemOptions.initialScreen) {
        case AppOnboardingScreen.launch:
          resolver.redirect(const LaunchRoute());
          break;
        case AppOnboardingScreen.welcome:
          resolver.redirect(WelcomeRoute());
          break;
        case AppOnboardingScreen.verifyId:
          resolver.redirect(const ProfileRoute());
          break;
        case AppOnboardingScreen.walkthrough:
          resolver.redirect(const WalkthroughRoute());
          break;
        case AppOnboardingScreen.home:
          resolver.redirect(const HomeRoute());
          break;
      }
    } else {
      resolver.next();
    }
  }
}
