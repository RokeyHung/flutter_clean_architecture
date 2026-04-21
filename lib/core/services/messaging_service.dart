// CORE - messaging_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import '../utils/app_logger.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.i('Background message: ${message.messageId}', tag: 'FCM');
}

class MessagingService {
  static const _tag = 'FCM';

  final FirebaseMessaging _messaging;

  MessagingService(this._messaging);

  static Future<void> init() async {
    AppLogger.i('Registering background handler', tag: _tag);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String?> getToken() async {
    final token = await _messaging.getToken();
    AppLogger.d('FCM token: $token', tag: _tag);
    return token;
  }

  Future<NotificationSettings> requestPermission() =>
      _messaging.requestPermission(alert: true, badge: true, sound: true);

  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();
}
