// CORE - iap_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// Khởi tạo và quản lý In-App Purchase.
/// Hiện tại chỉ init listener để sẵn sàng cho việc implement sau.
class IAPService {
  IAPService._();

  static final IAPService _instance = IAPService._();
  static IAPService get instance => _instance;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  /// Gọi trong main() trước khi runApp.
  static Future<void> init() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      debugPrint('[IAP] Store not available on this device');
      return;
    }
    _instance._listenToPurchaseUpdates();
    debugPrint('[IAP] In-App Purchase initialized');
  }

  void _listenToPurchaseUpdates() {
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: _subscription?.cancel,
      onError: (Object error) =>
          debugPrint('[IAP] Purchase stream error: $error'),
    );
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          debugPrint('[IAP] Purchase pending: ${purchase.productID}');
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // TODO: verify & deliver product
          debugPrint('[IAP] Purchase complete: ${purchase.productID}');
          _iap.completePurchase(purchase);
        case PurchaseStatus.error:
          debugPrint('[IAP] Purchase error: ${purchase.error}');
          _iap.completePurchase(purchase);
        case PurchaseStatus.canceled:
          debugPrint('[IAP] Purchase canceled: ${purchase.productID}');
      }
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
