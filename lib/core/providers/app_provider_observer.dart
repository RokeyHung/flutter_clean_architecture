// CORE - providers/app_provider_observer.dart
//
// Riverpod ProviderObserver — global error boundary & state change logger.
//
// Đăng ký trong ProviderScope tại main.dart:
//   ProviderScope(observers: [AppProviderObserver()], ...)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_logger.dart';

base class AppProviderObserver extends ProviderObserver {
  static const _tag = 'Riverpod';

  /// Ghi log khi provider có lỗi không được xử lý.
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    AppLogger.e(
      'Provider failed: ${context.provider.name ?? context.provider.runtimeType}',
      tag: _tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Ghi log khi provider được khởi tạo (chỉ ở debug mode).
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    AppLogger.d(
      'Provider added: ${context.provider.name ?? context.provider.runtimeType}',
      tag: _tag,
    );
  }

  /// Ghi log khi provider bị dispose.
  @override
  void didDisposeProvider(ProviderObserverContext context) {
    AppLogger.d(
      'Provider disposed: ${context.provider.name ?? context.provider.runtimeType}',
      tag: _tag,
    );
  }
}
