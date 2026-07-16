import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/sync_service.dart';

enum SyncConflictAction { merge, restore, backup }

/// Kimlik doğrulama ekranı için iş mantığı katmanı.
class AuthViewModel extends ChangeNotifier {
  final LocalStorageService _storage;
  final ApiService _api;
  final SyncService _sync;

  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel(this._storage, this._api, this._sync);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '327530541694-4khqa0mvmdv55huep74fjat3edbqdmvp.apps.googleusercontent.com',
  );

  /// 1. Google ile Giriş Akışı
  Future<bool> signInWithGoogle(BuildContext context, {required Function(bool hasCloudData) onLoginSuccess}) async {
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
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Google Kimlik Doğrulama Tokenı alınamadı.');
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
      onLoginSuccess(hasCloudData);
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// 3. İlk girişteki senkronizasyon kararını uygular.
  Future<void> resolveSyncConflict(SyncConflictAction action) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (action == SyncConflictAction.merge) {
        await _sync.mergeWithCloud();
      } else if (action == SyncConflictAction.restore) {
        await _sync.restoreFromCloud();
      } else if (action == SyncConflictAction.backup) {
        await _sync.backupToCloud();
      }
    } catch (e) {
      print('Çakışma çözümleme hatası: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 4. Yeni kullanıcı durumunda otomatik yedekleme yapar.
  Future<void> autoBackupNewUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _sync.backupToCloud();
    } catch (e) {
      print('Yeni kullanıcı otomatik yedekleme hatası: $e');
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
