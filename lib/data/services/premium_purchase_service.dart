import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_environment.dart';
import '../../localization/generated/strings.g.dart';
import 'api_service.dart';
import 'local_storage_service.dart';

enum MembershipTier { free, plus, premium }

MembershipTier membershipTierFromWire(Object? value) => switch (value) {
  'plus' => MembershipTier.plus,
  'premium' => MembershipTier.premium,
  _ => MembershipTier.free,
};

String membershipTierToWire(MembershipTier tier) => tier.name;

extension MembershipTierAccess on MembershipTier {
  bool includes(MembershipTier requiredTier) => index >= requiredTier.index;
}

/// Google Play satın alma akışını yönetir; erişim kararını yalnızca backend'den alır.
class PremiumPurchaseService extends ChangeNotifier {
  static String get plusProductId => AppEnvironment.googlePlayPlusProductId;
  static String get premiumProductId =>
      AppEnvironment.googlePlayPremiumProductId;

  static Set<String> get productIds => {plusProductId, premiumProductId};

  final LocalStorageService _storage;
  final ApiService _api;
  final InAppPurchase _store = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  final Map<MembershipTier, ProductDetails> _products = {};
  GooglePlayPurchaseDetails? _activeGooglePlayPurchase;
  MembershipTier _tier = MembershipTier.free;
  MembershipTier? _pendingTier;
  bool _isLoading = false;
  bool _isStoreAvailable = false;
  bool _initialized = false;
  String? _message;

  PremiumPurchaseService(this._storage, this._api);

  MembershipTier get tier => _tier;
  MembershipTier? get pendingTier => _pendingTier;
  bool get hasPaidAccess => _tier.includes(MembershipTier.plus);
  bool get isPremium => _tier == MembershipTier.premium;
  bool get isLoading => _isLoading;
  bool get isStoreAvailable => _isStoreAvailable;
  bool get isSignedIn => _storage.isUserLoggedIn;
  String? get message => _message;

  ProductDetails? productFor(MembershipTier tier) => _products[tier];

  String priceLabelFor(MembershipTier tier) =>
      _products[tier]?.price ?? t.premium.googlePlayPrice;

  bool isCurrentTier(MembershipTier candidate) => _tier == candidate;

  static MembershipTier? tierForProductId(String productId) {
    if (productId == plusProductId) return MembershipTier.plus;
    if (productId == premiumProductId) return MembershipTier.premium;
    return null;
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    _purchaseSubscription = _store.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (Object error) {
        _isLoading = false;
        _pendingTier = null;
        _message = t.premium.purchaseUpdateFailed(error: error);
        notifyListeners();
      },
    );

    await refreshEntitlement();
    await loadStoreProducts();
  }

  Future<void> refreshEntitlement() async {
    if (!isSignedIn) {
      _tier = MembershipTier.free;
      notifyListeners();
      return;
    }

    try {
      final result = await _api.fetchPremiumStatus();
      final membershipTier = result['membershipTier'];
      if (membershipTier is String) {
        _tier = membershipTierFromWire(membershipTier);
      } else if (result['isPremium'] == true) {
        _tier = MembershipTier.premium;
      } else if (result['hasPaidAccess'] == true) {
        _tier = MembershipTier.plus;
      } else {
        _tier = MembershipTier.free;
      }
    } on ApiException catch (error) {
      _message = error.message;
    } catch (_) {
      _message = t.premium.serverUnavailable;
    } finally {
      notifyListeners();
    }
  }

  Future<void> loadStoreProducts() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      _isStoreAvailable = false;
      notifyListeners();
      return;
    }

    try {
      _isStoreAvailable = await _store.isAvailable();
      if (!_isStoreAvailable) {
        _message = t.premium.storeUnavailable;
        notifyListeners();
        return;
      }

      final response = await _store.queryProductDetails(productIds);
      _products.clear();
      for (final product in response.productDetails) {
        final productTier = tierForProductId(product.id);
        if (productTier != null) _products[productTier] = product;
      }

      if (response.error != null) {
        _message = response.error!.message;
      } else if (_products.length != 2 || response.notFoundIDs.isNotEmpty) {
        _message = t.premium.productsNotFound;
      }

      await _loadActiveGooglePlayPurchase();
    } catch (error) {
      _isStoreAvailable = false;
      _message = t.premium.storeConnectionFailed(error: error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> purchase(MembershipTier targetTier) async {
    _message = null;
    if (targetTier == MembershipTier.free) {
      await manageSubscription();
      return;
    }
    if (!isSignedIn) {
      _message = t.premium.loginRequired;
      notifyListeners();
      return;
    }

    var product = _products[targetTier];
    if (product == null) {
      await loadStoreProducts();
      product = _products[targetTier];
      if (product == null) return;
    }

    final accountId = _storage.authGoogleId;
    if (accountId == null || !RegExp(r'^[a-f0-9]{64}$').hasMatch(accountId)) {
      _message = t.premium.invalidAccount;
      notifyListeners();
      return;
    }

    if (hasPaidAccess && _tier != targetTier) {
      await _loadActiveGooglePlayPurchase();
      if (_activeGooglePlayPurchase == null) {
        _message = t.premium.planChangeNeedsRestore;
        notifyListeners();
        return;
      }
    }

    _isLoading = true;
    _pendingTier = targetTier;
    notifyListeners();
    try {
      final PurchaseParam purchaseParam;
      if (defaultTargetPlatform == TargetPlatform.android) {
        final isPlanChange =
            _activeGooglePlayPurchase != null &&
            _activeGooglePlayPurchase!.productID != product.id;
        purchaseParam = GooglePlayPurchaseParam(
          productDetails: product,
          applicationUserName: accountId,
          changeSubscriptionParam: isPlanChange
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: _activeGooglePlayPurchase!,
                  replacementMode: targetTier.index > _tier.index
                      ? ReplacementMode.chargeProratedPrice
                      : ReplacementMode.deferred,
                )
              : null,
        );
      } else {
        purchaseParam = PurchaseParam(
          productDetails: product,
          applicationUserName: accountId,
        );
      }

      final launched = await _store.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      if (!launched) {
        _isLoading = false;
        _pendingTier = null;
        _message = t.premium.purchaseScreenFailed;
        notifyListeners();
      }
    } catch (error) {
      _isLoading = false;
      _pendingTier = null;
      _message = t.premium.purchaseStartFailed(error: error);
      notifyListeners();
    }
  }

  Future<void> manageSubscription() async {
    final currentProductId = switch (_tier) {
      MembershipTier.plus => plusProductId,
      MembershipTier.premium => premiumProductId,
      MembershipTier.free => null,
    };
    final uri = Uri.https('play.google.com', '/store/account/subscriptions', {
      ...(currentProductId == null
          ? const <String, String>{}
          : {'sku': currentProductId}),
      'package': AppEnvironment.googlePlayPackageName,
    });
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened) {
      _message = t.premium.subscriptionManagementFailed;
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    _message = null;
    if (!isSignedIn) {
      _message = t.premium.loginRestoreRequired;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();
    try {
      final accountId = _storage.authGoogleId;
      if (accountId == null || !RegExp(r'^[a-f0-9]{64}$').hasMatch(accountId)) {
        throw StateError(t.premium.invalidAccount);
      }
      await _store.restorePurchases(applicationUserName: accountId);
      await _loadActiveGooglePlayPurchase();
      _message = t.premium.checkingPurchases;
    } catch (error) {
      _message = t.premium.restoreFailed(error: error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadActiveGooglePlayPurchase() async {
    if (!_isStoreAvailable ||
        !isSignedIn ||
        defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    final accountId = _storage.authGoogleId;
    if (accountId == null) return;

    final addition = _store
        .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    final response = await addition.queryPastPurchases(
      applicationUserName: accountId,
    );
    final eligible = response.pastPurchases
        .where((purchase) => productIds.contains(purchase.productID))
        .toList(growable: false);
    if (eligible.isEmpty) {
      _activeGooglePlayPurchase = null;
      return;
    }

    final currentProductId = switch (_tier) {
      MembershipTier.plus => plusProductId,
      MembershipTier.premium => premiumProductId,
      MembershipTier.free => null,
    };
    _activeGooglePlayPurchase = eligible.firstWhere(
      (purchase) => purchase.productID == currentProductId,
      orElse: () => eligible.first,
    );
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (!productIds.contains(purchase.productID)) continue;

      if (purchase.status == PurchaseStatus.pending) {
        _isLoading = true;
        _message = t.premium.purchasePending;
        notifyListeners();
        continue;
      }

      if (purchase.status == PurchaseStatus.error) {
        _isLoading = false;
        _pendingTier = null;
        _message = purchase.error?.message ?? t.premium.purchaseFailed;
        notifyListeners();
        continue;
      }

      if (purchase.status == PurchaseStatus.canceled) {
        _isLoading = false;
        _pendingTier = null;
        _message = t.premium.purchaseCancelled;
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
    _message = t.premium.verifyingPurchase;
    notifyListeners();

    try {
      if (purchase.verificationData.source != 'google_play') {
        throw ApiException(t.premium.googlePlayOnly);
      }

      final result = await _api.verifyGooglePlayPurchase(
        purchaseToken: purchase.verificationData.serverVerificationData,
        productId: purchase.productID,
      );
      final verified = result['verified'] as bool? ?? false;
      final entitled =
          result['hasPaidAccess'] as bool? ??
          result['isPremium'] as bool? ??
          false;
      final verifiedTier = membershipTierFromWire(result['membershipTier']);
      if (!verified || !entitled || verifiedTier == MembershipTier.free) {
        throw ApiException(t.premium.noActivePremium);
      }

      _tier = verifiedTier;
      _pendingTier = null;
      if (purchase is GooglePlayPurchaseDetails) {
        _activeGooglePlayPurchase = purchase;
      }
      _message = t.premium.membershipActivated(
        plan: _displayName(verifiedTier),
      );

      if (purchase.pendingCompletePurchase) {
        await _store.completePurchase(purchase);
      }
    } on ApiException catch (error) {
      _message = error.message;
    } catch (error) {
      _message = t.premium.purchaseVerificationFailed(error: error);
    } finally {
      _isLoading = false;
      _pendingTier = null;
      notifyListeners();
    }
  }

  String _displayName(MembershipTier tier) => switch (tier) {
    MembershipTier.free => t.premium.freePlanName,
    MembershipTier.plus => t.premium.plusPlanName,
    MembershipTier.premium => t.premium.premiumPlanName,
  };

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    super.dispose();
  }
}
