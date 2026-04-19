// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/core_providers.dart';
import 'core/services/app_info_service.dart';
import 'core/services/firebase_service.dart';
import 'core/services/messaging_service.dart';
import 'core/services/remote_config_service.dart';
import 'features/todo/presentation/providers/todo_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Parallel init — chạy đồng thời để nhanh hơn
  final results = await Future.wait([
    SharedPreferences.getInstance(),
    AppInfoService.init(),
    FirebaseService.init(),
    MessagingService.init(),
    RemoteConfigService.init(),
  ]);

  final sharedPreferences = results[0] as SharedPreferences;
  final remoteConfig = results[4] as RemoteConfigService;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        remoteConfigServiceProvider.overrideWithValue(remoteConfig),
      ],
      child: const MyApp(),
    ),
  );
}

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
    // Log navigation history — urlState không có .stream, dùng router.current
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

    return MaterialApp.router(
      title: 'Flutter Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router.config(),
    );
  }
}
