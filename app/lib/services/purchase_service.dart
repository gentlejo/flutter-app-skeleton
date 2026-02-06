import 'dart:async';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:skeleton_app/common/config.dart';

/// In-app purchase service using RevenueCat.
///
/// Singleton with StreamController for subscription state.
class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  PurchaseService._internal();
  static PurchaseService get instance => _instance;

  final StreamController<CustomerInfo> _customerInfoController =
      StreamController<CustomerInfo>.broadcast();

  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;
  CustomerInfo? _currentCustomerInfo;
  CustomerInfo? get currentCustomerInfo => _currentCustomerInfo;

  Future<void> initialize() async {
    await Purchases.configure(
      PurchasesConfiguration(Config.revenueCatApiKey),
    );

    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      _currentCustomerInfo = customerInfo;
      _customerInfoController.add(customerInfo);
    });

    _currentCustomerInfo = await Purchases.getCustomerInfo();
    print('[PurchaseService] Initialized');
  }

  Future<List<Package>> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } catch (e) {
      print('[PurchaseService] Error getting offerings: $e');
      return [];
    }
  }

  Future<PurchaseResult?> purchase(Package package) async {
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      return result;
    } catch (e) {
      print('[PurchaseService] Error purchasing: $e');
      return null;
    }
  }

  Future<CustomerInfo?> restore() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo;
    } catch (e) {
      print('[PurchaseService] Error restoring: $e');
      return null;
    }
  }

  void dispose() {
    _customerInfoController.close();
  }
}
