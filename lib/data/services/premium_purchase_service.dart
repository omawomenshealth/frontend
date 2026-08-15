import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/config/app_environment.dart';
import '../../core/constants/app_strings.dart';
import 'api_service.dart';
import 'local_storage_service.dart';

/// Google Play satın alma akışını yönetir; erişim kararını yalnızca backend'den alır.
class PremiumPurchaseService extends ChangeNotifier {
  static String get productId => AppEnvironment.googlePlayPremiumProductId;

  final LocalStorageService _storage;
  final ApiService _api;
  final InAppPurchase _store = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  ProductDetails? _product;
  bool _isPremium = false;
  bool _isLoading = false;
  bool _isStoreAvailable = false;
  bool _initialized = false;
  String? _message;

  PremiumPurchaseService(this._storage, this._api);

  bool get isPremium => _isPremium;
  bool get isLoading => _isLoading;
  bool get isStoreAvailable => _isStoreAvailable;
  bool get isSignedIn => _storage.isUserLoggedIn;
  ProductDetails? get product => _product;
  String? get message => _message;
  String get priceLabel => _product?.price ?? AppStrings.googlePlayPrice;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    _purchaseSubscription = _store.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        _isLoading = false;
        _message = AppStrings.purchaseUpdateFailed(error);
        notifyListeners();
      },
    );

    await refreshEntitlement();
    await loadStoreProduct();
  }

  Future<void> refreshEntitlement() async {
    if (!isSignedIn) {
      _isPremium = false;
      notifyListeners();
      return;
    }

    try {
      final result = await _api.fetchPremiumStatus();
      _isPremium = result['isPremium'] as bool? ?? false;
    } on ApiException catch (error) {
      _message = error.message;
    } catch (_) {
      _message = AppStrings.premiumServerUnavailable;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadStoreProduct() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      _isStoreAvailable = false;
      notifyListeners();
      return;
    }

    try {
      _isStoreAvailable = await _store.isAvailable();
      if (!_isStoreAvailable) {
        _message = AppStrings.playStoreUnavailable;
        notifyListeners();
        return;
      }

      final response = await _store.queryProductDetails({productId});
      _product = response.productDetails.isEmpty
          ? null
          : response.productDetails.first;
      if (response.error != null) {
        _message = response.error!.message;
      } else if (_product == null) {
        _message = AppStrings.premiumProductNotFound;
      }
    } catch (error) {
      _isStoreAvailable = false;
      _message = AppStrings.playStoreConnectionFailed(error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> purchase() async {
    _message = null;
    if (!isSignedIn) {
      _message = AppStrings.loginBeforePremium;
      notifyListeners();
      return;
    }
    if (_product == null) {
      await loadStoreProduct();
      if (_product == null) return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      final accountId = _storage.authGoogleId;
      if (accountId == null || !RegExp(r'^[a-f0-9]{64}$').hasMatch(accountId)) {
        throw StateError('Premium hesap eşleştirme kimliği geçersiz.');
      }
      final purchaseParam = PurchaseParam(
        productDetails: _product!,
        applicationUserName: accountId,
      );
      final launched = await _store.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      if (!launched) {
        _isLoading = false;
        _message = AppStrings.purchaseScreenFailed;
        notifyListeners();
      }
    } catch (error) {
      _isLoading = false;
      _message = AppStrings.purchaseStartFailed(error);
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    _message = null;
    if (!isSignedIn) {
      _message = AppStrings.loginBeforeRestore;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      final accountId = _storage.authGoogleId;
      if (accountId == null || !RegExp(r'^[a-f0-9]{64}$').hasMatch(accountId)) {
        throw StateError('Premium hesap eşleştirme kimliği geçersiz.');
      }
      await _store.restorePurchases(applicationUserName: accountId);
      _message = AppStrings.checkingPurchases;
    } catch (error) {
      _message = AppStrings.restoreFailed(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.productID != productId) continue;

      if (purchase.status == PurchaseStatus.pending) {
        _isLoading = true;
        _message = AppStrings.purchasePending;
        notifyListeners();
        continue;
      }

      if (purchase.status == PurchaseStatus.error) {
        _isLoading = false;
        _message = purchase.error?.message ?? AppStrings.purchaseFailed;
        notifyListeners();
        continue;
      }

      if (purchase.status == PurchaseStatus.canceled) {
        _isLoading = false;
        _message = AppStrings.purchaseCancelled;
        notifyListeners();
        continue;
      }

      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        await _verifyAndDeliver(purchase);
      }
    }
  }

  Future<void> _verifyAndDeliver(PurchaseDetails purchase) async {
    _isLoading = true;
    _message = AppStrings.verifyingPurchase;
    notifyListeners();

    try {
      if (purchase.verificationData.source != 'google_play') {
        throw ApiException(AppStrings.googlePlayOnly);
      }

      final result = await _api.verifyGooglePlayPurchase(
        purchaseToken: purchase.verificationData.serverVerificationData,
        productId: purchase.productID,
      );
      final verified = result['verified'] as bool? ?? false;
      final entitled = result['isPremium'] as bool? ?? false;
      if (!verified || !entitled) {
        throw ApiException(AppStrings.noActivePremium);
      }

      _isPremium = true;
      _message = AppStrings.premiumActivated;

      if (purchase.pendingCompletePurchase) {
        await _store.completePurchase(purchase);
      }
    } on ApiException catch (error) {
      _message = error.message;
    } catch (error) {
      _message = AppStrings.purchaseVerificationFailed(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
