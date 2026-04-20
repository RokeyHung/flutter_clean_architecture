// CORE - providers (router + services)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../router/app_router.dart';
import '../services/auth_service.dart';
import '../services/messaging_service.dart';
import '../services/remote_config_service.dart';
import '../services/secure_storage_service.dart';
import '../services/storage_service.dart';

// ── Router ────────────────────────────────────────────────────────────────────

final appRouterProvider = Provider<AppRouter>((ref) => AppRouter());

// ── SharedPreferences (override in ProviderScope at main) ────────────────────

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError(
    'Override sharedPreferencesProvider in ProviderScope',
  ),
);

// ── Secure Storage ────────────────────────────────────────────────────────────

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(aOptions: AndroidOptions()),
);

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(ref.watch(flutterSecureStorageProvider));
});

// ── Firebase Auth ─────────────────────────────────────────────────────────────

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(firebaseAuthProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// ── Firebase Messaging ────────────────────────────────────────────────────────

final firebaseMessagingProvider = Provider<FirebaseMessaging>(
  (ref) => FirebaseMessaging.instance,
);

final messagingServiceProvider = Provider<MessagingService>((ref) {
  return MessagingService(ref.watch(firebaseMessagingProvider));
});

// ── Remote Config (injected from main after init) ─────────────────────────────

final remoteConfigServiceProvider = Provider<RemoteConfigService>(
  (ref) => throw UnimplementedError(
    'Override remoteConfigServiceProvider in ProviderScope',
  ),
);

// ── Firebase Storage + Image ──────────────────────────────────────────────────

final firebaseStorageProvider = Provider<FirebaseStorage>(
  (ref) => FirebaseStorage.instance,
);

final imagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(
    ref.watch(firebaseStorageProvider),
    ref.watch(imagePickerProvider),
  );
});
