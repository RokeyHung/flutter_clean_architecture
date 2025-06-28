import 'package:flutter_clean_architecture/gen/assets.gen.dart';
import 'package:flutter_clean_architecture/presentation/widgets/atom/app_icon.dart';

enum AppTab {
  timeline,
  movie,
  mypage,
}

enum AppAuthProvider {
  emailSignUp,
  emailSignIn,
  phone,
  migrate,
  unauthenticated,
}

class AppTabType {
  final AppTab tab;
  final String title;
  final SvgGenImage? icon;
  final AppIconProvider? iconProvider;
  final bool hidden;

  AppTabType({
    required this.tab,
    required this.title,
    this.icon,
    this.iconProvider,
    this.hidden = false,
  }) : assert(icon != null || iconProvider != null);

  AppIconProvider get finalIconProvider {
    return iconProvider ?? AppIconProvider.blueprint(icon!);
  }
}

class AppOptions {
  AppOptions({
    required this.name,
    required this.tabs,
  });

  final String name;

  final List<AppTabType> tabs;
}
