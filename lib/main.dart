// main.dart — shared bootstrap, KHÔNG chạy trực tiếp.
// Dùng: lib/main_dev.dart hoặc lib/main_prod.dart làm entry point.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_config.dart';
import 'core/config/app_config_provider.dart';
import 'core/providers/core_providers.dart';
import 'core/services/app_info_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/iap_service.dart';
import 'core/services/messaging_service.dart';
import 'core/services/remote_config_service.dart';
import 'core/settings/app_settings_notifier.dart';
import 'core/theme/app_theme_registry.dart';
import 'core/theme/material_theme_builder.dart';

/// Entry point dùng chung — được gọi từ main_dev.dart / main_prod.dart.
Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Parallel init
  final results = await Future.wait([
    SharedPreferences.getInstance(),
    AppInfoService.init(),
    FirebaseService.init(config),
    MessagingService.init(),
    RemoteConfigService.init(),
    IAPService.init(),
  ]);

  final sharedPreferences = results[0] as SharedPreferences;
  final remoteConfig = results[4] as RemoteConfigService;

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        remoteConfigServiceProvider.overrideWithValue(remoteConfig),
      ],
      child: const MyApp(),
    ),
  );
}

// ── App root ──────────────────────────────────────────────────────────────────

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    _initMessaging();
  }

  void _initDeepLinks() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('Router ready: ${ref.read(appRouterProvider).currentPath}');
    });
  }

  void _initMessaging() {
    final messaging = ref.read(messagingServiceProvider);
    messaging.requestPermission();
    messaging.onMessage.listen((msg) {
      debugPrint('FCM foreground: ${msg.notification?.title}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final config = ref.watch(appConfigProvider);
    final settings = ref.watch(appSettingsProvider);

    final textTheme = buildTextTheme(
      context,
      settings.fontBody,
      settings.fontDisplay,
    );
    final registry = buildThemeRegistry(textTheme);
    final appTheme = registry[settings.themeId] ?? registry[defaultThemeId]!;

    final brightness = View.of(context).platformDispatcher.platformBrightness;

    return MaterialApp.router(
      title: 'Flutter Clean Architecture',
      debugShowCheckedModeBanner: config.showDebugBanner,
      theme: appTheme.light(),
      darkTheme: appTheme.dark(),
      themeMode: brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      routerConfig: router.config(),
    );
  }
}
