import 'package:flutter/material.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';

/// Profil iş mantığı — kullanıcı bilgilerini görüntüleme ve güncelleme.
class ProfileViewModel extends ChangeNotifier {
  final LocalStorageService _storage;

  ProfileViewModel(this._storage) {
    loadSettings();
  }

  UserSettings _settings = UserSettings();
  bool _isLoading = true;
  bool _isSaving = false;

  UserSettings get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  bool get isFemale => _settings.gender == Gender.female;

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
    _settings = _settings.copyWith(averageCycleLength: value);
    notifyListeners();
  }

  void updateAveragePeriodLength(int value) {
    _settings = _settings.copyWith(averagePeriodLength: value);
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
    if (diseases.contains(disease)) {
      diseases.remove(disease);
    } else {
      diseases.add(disease);
    }
    _settings = _settings.copyWith(womenDiseases: diseases);
    notifyListeners();
  }

  void toggleChronicDisease(String disease) {
    final diseases = List<String>.from(_settings.chronicDiseases);
    if (diseases.contains(disease)) {
      diseases.remove(disease);
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
