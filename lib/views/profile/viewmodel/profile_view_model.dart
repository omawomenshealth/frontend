import 'package:flutter/material.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/models/lab_result_model.dart';
import '../../../data/models/medication_identity_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/notification_service.dart';

/// Profil iş mantığı — kullanıcı bilgilerini görüntüleme ve güncelleme.
import '../../../data/services/sync_service.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_strings.dart';

/// Profil iş mantığı — kullanıcı bilgilerini görüntüleme ve güncelleme.
class ProfileViewModel extends ChangeNotifier {
  final LocalStorageService _storage;
  final SyncService _sync;
  final ApiService _api;
  final NotificationService _notifications;

  ProfileViewModel(this._storage, this._sync, this._api, this._notifications) {
    loadSettings();
  }

  UserSettings _settings = UserSettings();
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSyncing = false;
  bool _isDeletingAccount = false;
  String? _syncError;

  UserSettings get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isSyncing => _isSyncing;
  bool get isDeletingAccount => _isDeletingAccount;
  String? get syncError => _syncError;
  List<String> get knownDiseases => {
    ..._settings.chronicDiseases,
    ..._settings.womenDiseases,
  }.toList(growable: false);

  // ── Kimlik Doğrulama & Senkronizasyon ──────────────────
  bool get isLoggedIn => _storage.isUserLoggedIn;
  String get userEmail => _storage.authEmail ?? '';
  String get userNameDisplay => _storage.authName ?? '';

  String get lastSyncDisplay {
    final timeStr = _storage.lastSyncTime;
    if (timeStr == null) return AppStrings.neverSynced;
    try {
      final dt = DateTime.parse(timeStr);
      return DateFormat(AppStrings.dateTimeDisplayPattern).format(dt);
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

  /// Çıkış Yap — Şifreli yerel veriler ile cihaz anahtarını temizler.
  Future<void> signOut(BuildContext context) async {
    await _api.logout();
    await _notifications.cancelAll();
    await _storage.clearAll();
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
    }
  }

  /// Kısa ömürlü sunucu doğrulamasını alır, bulut hesabını siler ve ancak
  /// sunucu onayından sonra cihazdaki kopyayı temizler.
  Future<bool> deleteAccountAndData(String confirmationEmail) async {
    if (!isLoggedIn || _isDeletingAccount) return false;
    _isDeletingAccount = true;
    _syncError = null;
    notifyListeners();

    try {
      final deletionToken = await _api.createAccountDeletionChallenge(
        confirmationEmail,
      );
      await _api.deleteAccount(deletionToken);
      await _notifications.cancelAll();
      final cleared = await _storage.clearAll();
      return cleared || await _storage.clearAll();
    } on ApiException catch (error) {
      _syncError = error.message;
      return false;
    } catch (_) {
      _syncError = AppStrings.deletionFailed;
      return false;
    } finally {
      _isDeletingAccount = false;
      notifyListeners();
    }
  }

  /// Hesap bağlanmamışsa yalnızca bu cihazdaki verileri siler.
  Future<bool> deleteLocalData() async {
    if (_isDeletingAccount) return false;
    _isDeletingAccount = true;
    _syncError = null;
    notifyListeners();
    try {
      await _notifications.cancelAll();
      final cleared = await _storage.clearAll();
      return cleared || await _storage.clearAll();
    } finally {
      _isDeletingAccount = false;
      notifyListeners();
    }
  }

  void navigateAfterDeletion(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
  }

  /// Ayarları yükle.
  void loadSettings() {
    final loaded = _storage.loadSettings() ?? UserSettings();
    _settings = loaded.copyWith(
      chronicDiseases: loaded.chronicDiseases
          .where((value) => !_isLegacyOther(value))
          .toList(growable: false),
      womenDiseases: loaded.womenDiseases
          .where((value) => !_isLegacyOther(value))
          .toList(growable: false),
    );
    _isLoading = false;
    notifyListeners();
  }

  bool _isLegacyOther(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'diğer' || normalized == 'other';
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

  void updateLaboratoryResults({
    required Map<String, LabResult> results,
    required DateTime? testDate,
    required bool? fasting,
  }) {
    _settings = _settings.copyWith(
      labResults: Map<String, LabResult>.from(results),
      labTestDate: testDate,
      clearLabTestDate: testDate == null,
      labTestFasting: fasting,
      clearLabTestFasting: fasting == null,
    );
    notifyListeners();
  }

  // ── Kadın Sağlığı Güncellemeleri ─────────────────────

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

  void addWomenDisease(String disease) {
    final value = disease.trim();
    if (value.isEmpty || _containsCondition(_settings.womenDiseases, value)) {
      return;
    }
    _settings = _settings.copyWith(
      womenDiseases: [..._settings.womenDiseases, value],
    );
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

  void addChronicDisease(String disease) {
    final value = disease.trim();
    if (value.isEmpty || _containsCondition(_settings.chronicDiseases, value)) {
      return;
    }
    _settings = _settings.copyWith(
      chronicDiseases: [..._settings.chronicDiseases, value],
    );
    notifyListeners();
  }

  void toggleKnownDisease(String disease) {
    final diseases = List<String>.from(knownDiseases);
    final existingIndex = diseases.indexWhere(
      (value) =>
          AppStrings.localizeStoredValue(value).trim().toLowerCase() ==
          disease.trim().toLowerCase(),
    );
    if (existingIndex >= 0) {
      diseases.removeAt(existingIndex);
    } else {
      diseases.add(disease);
    }
    _settings = _settings.copyWith(
      chronicDiseases: diseases,
      womenDiseases: const [],
    );
    notifyListeners();
  }

  void addKnownDisease(String disease) {
    final value = disease.trim();
    if (value.isEmpty || _containsCondition(knownDiseases, value)) return;
    _settings = _settings.copyWith(
      chronicDiseases: [...knownDiseases, value],
      womenDiseases: const [],
    );
    notifyListeners();
  }

  bool _containsCondition(List<String> values, String candidate) => values.any(
    (value) =>
        AppStrings.localizeStoredValue(value).trim().toLowerCase() ==
        candidate.toLowerCase(),
  );

  // ── İlaç & Takviye ──────────────────────────────────

  void addMedication(MedicationIdentity medication) {
    if (!_settings.dailyMedications.contains(medication)) {
      final meds = List<MedicationIdentity>.from(_settings.dailyMedications)
        ..add(medication);
      _settings = _settings.copyWith(dailyMedications: meds);
      notifyListeners();
    }
  }

  void removeMedication(MedicationIdentity medication) {
    final meds = List<MedicationIdentity>.from(_settings.dailyMedications)
      ..remove(medication);
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

  void addSkincare(String name) {
    if (name.isNotEmpty && !_settings.dailySkincare.contains(name)) {
      final items = List<String>.from(_settings.dailySkincare)..add(name);
      _settings = _settings.copyWith(dailySkincare: items);
      notifyListeners();
    }
  }

  void removeSkincare(String name) {
    final items = List<String>.from(_settings.dailySkincare)..remove(name);
    _settings = _settings.copyWith(dailySkincare: items);
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
