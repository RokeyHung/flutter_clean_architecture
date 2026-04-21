// CORE - iap_service.dart
import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../utils/app_logger.dart';

/// Khởi tạo và quản lý In-App Purchase.
/// Hiện tại chỉ init listener để sẵn sàng cho việc implement sau.
class IAPService {
  static const _tag = 'IAP';

  IAPService._();

  static final IAPService _instance = IAPService._();
  static IAPService get instance => _instance;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Gọi trong main() trước khi runApp.
  static Future<void> init() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      AppLogger.w('Store not available on this device', tag: _tag);
      return;
    }
    _instance._listenToPurchaseUpdates();
    AppLogger.i('In-App Purchase initialized', tag: _tag);
  }

  void _listenToPurchaseUpdates() {
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: _subscription?.cancel,
      onError: (Object error, StackTrace st) => AppLogger.e(
        'Purchase stream error',
        tag: _tag,
        error: error,
        stackTrace: st,
      ),
    );
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          AppLogger.d('Purchase pending: ${purchase.productID}', tag: _tag);
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // TODO: verify & deliver product
          AppLogger.i('Purchase complete: ${purchase.productID}', tag: _tag);
          _iap.completePurchase(purchase);
        case PurchaseStatus.error:
          AppLogger.e(
            'Purchase error: ${purchase.productID}',
            tag: _tag,
            error: purchase.error,
          );
          _iap.completePurchase(purchase);
        case PurchaseStatus.canceled:
          AppLogger.d('Purchase canceled: ${purchase.productID}', tag: _tag);
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
