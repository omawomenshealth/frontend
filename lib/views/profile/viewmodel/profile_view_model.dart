import 'package:flutter/material.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../core/utils/cycle_rules.dart';

/// Profil iş mantığı — kullanıcı bilgilerini görüntüleme ve güncelleme.
import '../../../data/services/sync_service.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_strings.dart';

/// Profil iş mantığı — kullanıcı bilgilerini görüntüleme ve güncelleme.
class ProfileViewModel extends ChangeNotifier {
  final LocalStorageService _storage;
  final SyncService _sync;

  ProfileViewModel(this._storage, this._sync) {
    loadSettings();
  }

  UserSettings _settings = UserSettings();
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSyncing = false;
  String? _syncError;

  UserSettings get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isSyncing => _isSyncing;
  String? get syncError => _syncError;

  // ── Kimlik Doğrulama & Senkronizasyon ──────────────────
  bool get isLoggedIn => _storage.isUserLoggedIn;
  String get userEmail => _storage.authEmail ?? '';
  String get userNameDisplay => _storage.authName ?? '';

  String get lastSyncDisplay {
    final timeStr = _storage.lastSyncTime;
    if (timeStr == null) return AppStrings.neverSynced;
    try {
      final dt = DateTime.parse(timeStr);
      return DateFormat(
        AppStrings.isTurkish ? 'dd.MM.yyyy HH:mm' : 'MM/dd/yyyy h:mm a',
      ).format(dt);
    } catch (_) {
      return AppStrings.unknown;
    }
  }

  /// Manuel senkronizasyonu başlat (Bulutla Birleştir)
  Future<bool> syncNow() async {
    if (!isLoggedIn) return false;
    _isSyncing = true;
    _syncError = null;
    notifyListeners();

    try {
      final success = await _sync.mergeWithCloud();
      if (success) {
        // Senkronizasyondan sonra yerel ayarları ve log istatistiklerini yeniden yükle
        loadSettings();
      } else {
        _syncError = AppStrings.syncInternetFailed;
      }
      return success;
    } catch (e) {
      _syncError = e.toString();
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  /// Çıkış Yap — Tüm SharedPreferences verilerini temizler ve Auth ekranına yönlendirir.
  Future<void> signOut(BuildContext context) async {
    await _storage.clearAll();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
    }
  }

  /// Ayarları yükle.
  void loadSettings() {
    _settings = _storage.loadSettings() ?? UserSettings();
    _isLoading = false;
    notifyListeners();
  }

  // ── Temel Bilgi Güncellemeleri ────────────────────────

  void updateUserName(String value) {
    _settings = _settings.copyWith(userName: value);
    notifyListeners();
  }

  void updateWeight(double? value) {
    _settings = _settings.copyWith(weight: value);
    notifyListeners();
  }

  void updateHeight(double? value) {
    _settings = _settings.copyWith(height: value);
    notifyListeners();
  }

  void updateAge(int? value) {
    _settings = _settings.copyWith(age: value);
    notifyListeners();
  }

  void updateIsSmoker(bool value) {
    _settings = _settings.copyWith(
      isSmoker: value,
      smokingYears: value ? _settings.smokingYears : 0,
    );
    notifyListeners();
  }

  void updateSmokingYears(int value) {
    _settings = _settings.copyWith(smokingYears: value);
    notifyListeners();
  }

  void updateRelationshipStatus(String value) {
    _settings = _settings.copyWith(relationshipStatus: value);
    notifyListeners();
  }

  void updateSexuallyActive(bool? value) {
    _settings = _settings.copyWith(sexuallyActive: value);
    notifyListeners();
  }

  void updateWantsChildrenInYear(bool? value) {
    _settings = _settings.copyWith(wantsChildrenInYear: value);
    notifyListeners();
  }

  void updateBloodTestResults(String? value) {
    _settings = _settings.copyWith(bloodTestResults: value);
    notifyListeners();
  }

  // ── Kadın Sağlığı Güncellemeleri ─────────────────────

  void updateAverageCycleLength(int value) {
    _settings = _settings.copyWith(
      averageCycleLength: CycleRules.sanitizeCycleLength(value),
    );
    notifyListeners();
  }

  void updateAveragePeriodLength(int value) {
    _settings = _settings.copyWith(
      averagePeriodLength: CycleRules.sanitizePeriodLength(value),
    );
    notifyListeners();
  }

  void updateLastPeriodDate(DateTime? value) {
    _settings = _settings.copyWith(lastPeriodDate: value);
    notifyListeners();
  }

  void updateMenopauseStatus(MenopauseStatus value) {
    _settings = _settings.copyWith(menopauseStatus: value);
    notifyListeners();
  }

  void updateBirthControlMethod(String? value) {
    _settings = _settings.copyWith(birthControlMethod: value);
    notifyListeners();
  }

  void toggleWomenDisease(String disease) {
    final diseases = List<String>.from(_settings.womenDiseases);
    final existingIndex = diseases.indexWhere(
      (value) => AppStrings.localizeStoredValue(value) == disease,
    );
    if (existingIndex >= 0) {
      diseases.removeAt(existingIndex);
    } else {
      diseases.add(disease);
    }
    _settings = _settings.copyWith(womenDiseases: diseases);
    notifyListeners();
  }

  void toggleChronicDisease(String disease) {
    final diseases = List<String>.from(_settings.chronicDiseases);
    final existingIndex = diseases.indexWhere(
      (value) => AppStrings.localizeStoredValue(value) == disease,
    );
    if (existingIndex >= 0) {
      diseases.removeAt(existingIndex);
    } else {
      diseases.add(disease);
    }
    _settings = _settings.copyWith(chronicDiseases: diseases);
    notifyListeners();
  }

  // ── İlaç & Takviye ──────────────────────────────────

  void addMedication(String name) {
    if (name.isNotEmpty && !_settings.dailyMedications.contains(name)) {
      final meds = List<String>.from(_settings.dailyMedications)..add(name);
      _settings = _settings.copyWith(dailyMedications: meds);
      notifyListeners();
    }
  }

  void removeMedication(String name) {
    final meds = List<String>.from(_settings.dailyMedications)..remove(name);
    _settings = _settings.copyWith(dailyMedications: meds);
    notifyListeners();
  }

  void addSupplement(String name) {
    if (name.isNotEmpty && !_settings.dailySupplements.contains(name)) {
      final sups = List<String>.from(_settings.dailySupplements)..add(name);
      _settings = _settings.copyWith(dailySupplements: sups);
      notifyListeners();
    }
  }

  void removeSupplement(String name) {
    final sups = List<String>.from(_settings.dailySupplements)..remove(name);
    _settings = _settings.copyWith(dailySupplements: sups);
    notifyListeners();
  }

  // ── Kaydet ──────────────────────────────────────────

  /// Tüm değişiklikleri kaydet.
  Future<bool> saveSettings() async {
    _isSaving = true;
    notifyListeners();

    final success = await _storage.saveSettings(_settings);

    _isSaving = false;
    notifyListeners();

    return success;
  }
}
