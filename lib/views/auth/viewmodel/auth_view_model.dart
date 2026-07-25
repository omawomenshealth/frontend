import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/sync_service.dart';
import '../../../core/constants/app_strings.dart';

enum SyncConflictAction { merge, restore, backup }

/// Kimlik doğrulama ekranı için iş mantığı katmanı.
class AuthViewModel extends ChangeNotifier {
  final LocalStorageService _storage;
  final ApiService _api;
  final SyncService _sync;

  bool _isLoading = false;
  String? _errorMessage;
  bool _privacyConsentRequired = false;
  String _privacyNoticeVersion = '2026-07-24';

  AuthViewModel(this._storage, this._api, this._sync);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get privacyConsentRequired => _privacyConsentRequired;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '327530541694-ejaruugjsku3e0qfkq77cloqt15095ql.apps.googleusercontent.com',
  );

  /// 1. Google ile Giriş Akışı
  Future<bool> signInWithGoogle(
    BuildContext context, {
    required Function(bool hasCloudData) onLoginSuccess,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Google Giriş Penceresini Aç
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Kullanıcı giriş penceresini kapattı
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Kimlik bilgilerini (ID Token) al
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception(AppStrings.googleTokenMissing);
      }

      // Backend API'ye gönder
      final response = await _api.loginWithGoogle(
        idToken,
        email: googleUser.email,
        name: googleUser.displayName,
      );

      _isLoading = false;
      notifyListeners();

      final bool hasCloudData = response['hasCloudData'] as bool? ?? false;
      _readPrivacyState(response);
      onLoginSuccess(hasCloudData);
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 2. Geliştirici / Simülatör Test Girişi (Mock Login)
  Future<bool> signInSimulated(
    BuildContext context, {
    required String email,
    required String name,
    required Function(bool hasCloudData) onLoginSuccess,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Backend'e sahte token ve kullanıcı bilgileri gönder
      final response = await _api.loginWithGoogle(
        'mock_google_id_token',
        email: email,
        name: name,
      );

      _isLoading = false;
      notifyListeners();

      final bool hasCloudData = response['hasCloudData'] as bool? ?? false;
      _readPrivacyState(response);
      onLoginSuccess(hasCloudData);
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void _readPrivacyState(Map<String, dynamic> response) {
    final privacy = response['privacy'];
    if (privacy is Map<String, dynamic>) {
      _privacyConsentRequired = privacy['granted'] != true;
      _privacyNoticeVersion =
          privacy['noticeVersion'] as String? ?? _privacyNoticeVersion;
    } else {
      _privacyConsentRequired = true;
    }
  }

  Future<bool> grantPrivacyConsent() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _api.grantPrivacyConsent(_privacyNoticeVersion);
      _privacyConsentRequired = false;
      return true;
    } catch (error) {
      _errorMessage = error is ApiException
          ? error.message
          : AppStrings.privacyActionFailed;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 3. İlk girişteki senkronizasyon kararını uygular.
  Future<bool> resolveSyncConflict(SyncConflictAction action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      bool success;
      if (action == SyncConflictAction.merge) {
        success = await _sync.mergeWithCloud();
      } else if (action == SyncConflictAction.restore) {
        success = await _sync.restoreFromCloud();
      } else if (action == SyncConflictAction.backup) {
        success = await _sync.backupToCloud();
      } else {
        success = false;
      }
      if (!success) {
        _errorMessage = AppStrings.syncProtectedError;
      }
      return success;
    } catch (e) {
      _errorMessage = AppStrings.syncError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool get hasCompletedOnboarding => _storage.isOnboardingComplete;

  /// Yerelde tamamlanmış profil varsa yeni bulut hesabına yedekler.
  Future<bool> backupCompletedProfile() async {
    if (!hasCompletedOnboarding) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final success = await _sync.backupToCloud();
      if (!success) {
        _errorMessage = AppStrings.profileBackupFailed;
      }
      return success;
    } catch (e) {
      _errorMessage = AppStrings.cloudBackupError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Kullanıcının sonraki ekrana yönlendirilmesini belirler.
  String determineNextRoute() {
    final settings = _storage.loadSettings();
    if (settings != null && settings.isOnboardingComplete) {
      return '/home';
    }
    return '/onboarding';
  }
}
