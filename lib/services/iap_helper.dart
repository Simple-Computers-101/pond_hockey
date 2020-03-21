import 'dart:async';
import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pond_hockey/models/user.dart';
import 'package:pond_hockey/services/databases/user_repository.dart';
import 'package:pond_hockey/utils/product_ids.dart';

class IAPHelper {
  static final IAPHelper _instance = IAPHelper._internal();

  factory IAPHelper() => _instance;

  IAPHelper._internal();

  StreamSubscription _sub;
  User user;

  bool isAvailable = true;

  List<ProductDetails> products = [];
  List<PurchaseDetails> purchases = [];

  InAppPurchaseConnection _iap;

  /// Returns whether or not it was initialized
  Future<bool> initialize() async {
    if (Platform.isAndroid) {
      InAppPurchaseConnection.enablePendingPurchases();
    }
    _iap = InAppPurchaseConnection.instance;
    isAvailable = await _iap.isAvailable();
    user = await UserRepository().getCurrentUser();

    if (isAvailable && user != null) {
      await _getPastPurchases();
      await _getProducts();
      _sub = _iap.purchaseUpdatedStream.listen((data) {
        purchases.addAll(data);
        verifyPurchase();
      });
      return true;
    }
    return false;
  }

  Future<void> _getProducts() async {
    final ids = {ProductIds.creditsOnePackId, ProductIds.creditsThreePackId};
    final response = await _iap.queryProductDetails(ids);

    products = response.productDetails;
  }

  Future<void> _getPastPurchases() async {
    var response = await _iap.queryPastPurchases();

    for (final purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        InAppPurchaseConnection.instance.completePurchase(purchase);
      }
    }

    purchases = response.pastPurchases;
  }

  PurchaseDetails hasPurchased(String productId) {
    return purchases.firstWhere(
      (element) => element.productID == productId,
      orElse: () => null,
    );
  }

  void buyCredits(ProductDetails prod) {
    final purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
  }

  void verifyPurchase() {
    final purchase = purchases.first;

    if (purchase == null || purchase?.status != PurchaseStatus.purchased) {
      return null;
    }

    if (purchase.productID == ProductIds.creditsOnePackId) {
      UserRepository().addCredits(user.uid, 1);
    } else if (purchase.productID == ProductIds.creditsThreePackId) {
      UserRepository().addCredits(user.uid, 3);
    }
  }

  void dispose() {
    _sub.cancel();
  }
}
