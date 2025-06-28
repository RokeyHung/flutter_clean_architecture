import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/core/utils/async_util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

const _kMobileDestinationKey = 'mobile_destination';

@pragma('vm:entry-point')
Future<void> _onFirebaseMessagingBackgroundMessage(
  RemoteMessage remoteMessage,
) async {
  final instance = WidgetsFlutterBinding.ensureInitialized().platformDispatcher;
  final originalOnError = instance.onError;
  instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return originalOnError?.call(error, stack) ?? true;
  };
  final app = await Firebase.initializeApp();
  await FirebaseInitializer.crashlytics(app, enabled: kReleaseMode);
  await FirebaseInitializer.messaging();

  await FirebaseInitializer.updateBadgeCountFromRemoteMessage(remoteMessage);
}

class FirebaseInitializer {
  const FirebaseInitializer._();

  static late final FirebasePerformance kPerformanceMonitor;
  static bool isFirebaseMessagingInitialized = false;

  static late final FlutterLocalNotificationsPlugin localNotifications;
  static AndroidNotificationChannel? androidNotificationChannel;
  static final selectLocalNotification =
      StreamController<RemoteMessage>.broadcast();

  static Future<FirebaseApp> app(FirebaseOptions options) async {
    try {
      final firebaseApp = await Firebase.initializeApp(
        name: defaultFirebaseAppName,
        options: options,
      );
      return firebaseApp;
    } on Exception catch (_) {
      return Firebase.app(defaultFirebaseAppName);
    }
  }

  static Future<FirebaseAppCheck> appCheck(FirebaseApp app) async {
    final appCheck = FirebaseAppCheck.instance;
    appCheck.app = app;
    if (kDebugMode) {
      await appCheck.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    } else {
      await appCheck.activate();
    }
    return appCheck;
  }

  static Future<FirebaseCrashlytics> crashlytics(
    FirebaseApp app, {
    required bool enabled,
  }) async {
    final crashlytics = FirebaseCrashlytics.instance;
    crashlytics.app = app;
    await crashlytics.sendUnsentReports();
    await crashlytics.setCrashlyticsCollectionEnabled(enabled);

    {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (errorDetails) async {
        await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
        originalOnError?.call(errorDetails);
      };
    }

    {
      final platformDispatcher = PlatformDispatcher.instance;
      final originalOnError = platformDispatcher.onError;
      platformDispatcher.onError = (error, stack) {
        unawaited(
          FirebaseCrashlytics.instance.recordError(
            error,
            stack,
            fatal: error is Error,
          ),
        );
        return originalOnError?.call(error, stack) ?? true;
      };
    }

    {
      Isolate.current.addErrorListener(RawReceivePort(
        (pair) async {
          await crashlytics.recordError(
            pair.first,
            pair.last is StackTrace
                ? pair.last
                : pair.last is String
                    ? StackTrace.fromString(pair.last)
                    : null,
            fatal: true,
          );
        },
      ).sendPort);
    }

    {
      final originalDemangle = FlutterError.demangleStackTrace;
      FlutterError.demangleStackTrace = (details) {
        if (details is stack_trace.Chain) {
          return details
              .foldFrames((frame) => isCorePackagesFrame(frame))
              .toTrace()
              .vmTrace;
        }
        if (details is stack_trace.Trace) {
          return details
              .foldFrames((frame) => isCorePackagesFrame(frame))
              .vmTrace;
        }
        return originalDemangle(details);
      };
    }

    if (enabled) {
      final originalDebugPrint = debugPrint;
      debugPrint = (message, {wrapWidth}) {
        if (message != null) {
          crashlytics.log(message);
        }
        originalDebugPrint(message, wrapWidth: wrapWidth);
      };
    }

    return crashlytics;
  }

  static bool isCorePackagesFrame(stack_trace.Frame frame) {
    const deniedPackages = <String>[
      'dart',
      'flutter',
    ];
    return frame.isCore || deniedPackages.contains(frame.package);
  }

  static Future<FirebaseRemoteConfig> remoteConfig(FirebaseApp app) async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    assert(remoteConfig.app == app);

    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval:
            kDebugMode ? Duration.zero : const Duration(minutes: 15),
      ),
    );
    await remoteConfig.setDefaults(
      <String, dynamic>{
        'max_force_login_version': '99.99.99',
        'max_force_login_build_number': '999999',
      },
    );
    try {
      await remoteConfig.fetchAndActivate();
    } catch (e, s) {
      await FirebaseCrashlytics.instance.recordError(e, s);
    }
    return remoteConfig;
  }

  static Future<FirebaseAuth> auth(
    FirebaseApp app, {
    String? languageCode,
  }) async {
    final auth = FirebaseAuth.instance;
    auth.app = app;
    await auth.setLanguageCode(languageCode);
    await auth.authStateChanges().first;
    return auth;
  }

  static Future<void> messaging() async {
    if (!isFirebaseMessagingInitialized) {
      isFirebaseMessagingInitialized = true;

      try {
        FirebaseMessaging.onBackgroundMessage(
          _onFirebaseMessagingBackgroundMessage,
        );

        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        localNotifications = FlutterLocalNotificationsPlugin();
        await localNotifications.initialize(
          InitializationSettings(
            android: Platform.isAndroid
                ? const AndroidInitializationSettings('ic_notification')
                : null,
            iOS: Platform.isIOS
                ? const DarwinInitializationSettings(
                    requestAlertPermission: false,
                    requestBadgePermission: false,
                    requestSoundPermission: false,
                  )
                : null,
          ),
          onDidReceiveNotificationResponse: (response) {
            selectLocalNotification.add(
              RemoteMessage.fromMap(jsonDecode(response.payload ?? '')),
            );
          },
        );
        if (Platform.isAndroid) {
          androidNotificationChannel = const AndroidNotificationChannel(
            'default_notification_channel', // from AndroidManifest.xml
            '通知', // from default value
          );
          await localNotifications
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.createNotificationChannel(
                androidNotificationChannel!,
              );
        }

        // await AppBadge.instance.clearIfZero();
      } catch (e, s) {
        await FirebaseCrashlytics.instance.recordError(e, s);
      }
    }
  }

  static Future<void> dynamicLinks({required StackRouter router}) async {
    void processDeepLink(Uri deepLink) {
      final inAppPath = deepLink.queryParameters['inapp'];
      final inAppUri = inAppPath != null ? Uri.tryParse(inAppPath) : null;
      final uri = inAppUri ?? deepLink;
      if (router.currentPath != uri.path) {
        final path = uri.hasQuery ? '${uri.path}?${uri.query}' : uri.path;
        dispatchMicroTask(
          () async => await router.navigateNamed(
            path,
            includePrefixMatches: true,
          ),
        );
      }
    }

    final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    debugPrint('DynamicLinks: initialLink: $initialLink');
    if (initialLink != null) {
      processDeepLink(initialLink.link);
    }

    FirebaseDynamicLinks.instance.onLink.listen((pendingDynamicLinkData) {
      debugPrint('DynamicLinks: ${pendingDynamicLinkData.link}');
      processDeepLink(pendingDynamicLinkData.link);
    }).onError((error) {
      debugPrint('DynamicLinks: handle deeplink error: $error');
    });
  }

  static Future<void> waitMessaging({required StackRouter router}) async {
    void handleMessage(RemoteMessage? message) {
      final data = message?.data;
      final destination = data != null ? data[_kMobileDestinationKey] : null;
      if (destination != null) {
        if (router.currentPath != destination) {
          dispatchMicroTask(
            () async => await router.navigateNamed(
              destination,
              includePrefixMatches: true,
            ),
          );
        }
      }
    }

    // アプリがフォアグラウンド状態の時に通知を受け取った場合
    FirebaseMessaging.onMessage.listen((message) async {
      if (Platform.isAndroid) {
        showNotificationFromRemote(message);
      }
      await updateBadgeCountFromRemoteMessage(message);
    });

    // アプリがバックグラウンドで起動状態の時に通知をタップした場合
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // アプリがバックグラウンドやタスクキルによって止まっていて再起動した場合
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    // app が生成した通知をフォアグラウンドでタップした場合
    selectLocalNotification.stream.listen(handleMessage);

    // app が生成した通知をバックグラウンドでタップした場合
    final initialLocalMessage =
        await localNotifications.getNotificationAppLaunchDetails();
    if (initialLocalMessage != null &&
        initialLocalMessage.didNotificationLaunchApp) {
      handleMessage(
        RemoteMessage.fromMap(
          jsonDecode(initialLocalMessage.notificationResponse?.payload ?? ''),
        ),
      );
    }
  }

  static void showNotificationFromRemote(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) {
      return;
    }

    final android = notification.android;
    if (Platform.isAndroid && android == null) {
      return;
    }

    final apple = notification.apple;
    if (Platform.isIOS && apple == null) {
      return;
    }

    localNotifications.show(
      int.tryParse(message.messageId ?? '') ?? (message.hashCode & 0x7fffffff),
      notification.title,
      notification.body,
      NotificationDetails(
        android: android != null
            ? AndroidNotificationDetails(
                android.channelId ?? androidNotificationChannel?.id ?? '',
                androidNotificationChannel?.name ?? '',
                channelDescription: androidNotificationChannel?.description,
                priority: Priority.high,
                importance: Importance.high,
                icon: android.smallIcon,
              )
            : null,
        iOS: apple != null
            ? DarwinNotificationDetails(
                subtitle: apple.subtitle,
                presentBadge: apple.badge != null,
                badgeNumber: int.tryParse(apple.badge ?? ''),
                presentSound: apple.sound != null,
                sound: apple.sound?.name,
              )
            : null,
      ),
      payload: jsonEncode(message.toMap()), // for Firebase Messaging.
    );
  }

  static Future<void> performanceMonitor(FirebaseApp app) async {
    kPerformanceMonitor = FirebasePerformance.instanceFor(app: app);
  }

  static int? extractBadgeCount(RemoteMessage remoteMessage) {
    final data = Platform.isIOS
        ? remoteMessage.notification?.apple?.badge ?? ''
        : remoteMessage.data['badge_count'];
    return data is String ? int.tryParse(data) : data as int?;
  }

  static Future<void> updateBadgeCountFromRemoteMessage(
    RemoteMessage remoteMessage,
  ) async {
    final count = extractBadgeCount(remoteMessage);
    if (count != null) {
      // AppBadge.instance.setCount(count);
    }
  }
}
