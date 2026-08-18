import 'package:flutter/material.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/models/lab_result_model.dart';
import '../../../data/models/medication_identity_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/sync_service.dart';
import '../../../core/utils/cycle_rules.dart';
import '../../../core/constants/app_strings.dart';

/// Onboarding iş mantığı — adım adım kullanıcı bilgisi toplama.
class OnboardingViewModel extends ChangeNotifier {
  final LocalStorageService _storage;
  final SyncService _sync;

  OnboardingViewModel(this._storage, this._sync);

  // ── Sayfa kontrolü ────────────────────────────────────
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // Toplam sayfa sayısı cinsiyete göre değişir
  int get totalPages => 3;

  // ── Form verileri ─────────────────────────────────────
  String _userName = '';
  bool _isSmoker = false;
  int _smokingYears = 0;
  double? _weight;
  double? _height;
  int? _age;
  DateTime? _birthDate;
  String _relationshipStatus = AppStrings.relationshipStatusOptions.last;
  bool? _sexuallyActive;
  bool? _wantsChildrenInYear;
  Map<String, LabResult> _labResults = {};
  DateTime? _labTestDate;
  bool? _labTestFasting;
  List<String> _chronicDiseases = [];

  // Kadın
  int _averageCycleLength = CycleRules.defaultCycleLength;
  int _averagePeriodLength = CycleRules.defaultPeriodLength;
  bool _isCycleLengthUnknown = false;
  DateTime? _lastPeriodDate;
  MenopauseStatus _menopauseStatus = MenopauseStatus.none;
  String? _birthControlMethod;
  List<String> _womenDiseases = [];

  // İlaç & Takviye
  List<MedicationIdentity> _dailyMedications = [];
  List<String> _dailySupplements = [];

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  // ── Getter'lar ────────────────────────────────────────
  String get userName => _userName;
  bool get isSmoker => _isSmoker;
  int get smokingYears => _smokingYears;
  double? get weight => _weight;
  double? get height => _height;
  int? get age => _age;
  DateTime? get birthDate => _birthDate;
  String get relationshipStatus => _relationshipStatus;
  bool? get sexuallyActive => _sexuallyActive;
  bool? get wantsChildrenInYear => _wantsChildrenInYear;
  Map<String, LabResult> get labResults => _labResults;
  DateTime? get labTestDate => _labTestDate;
  bool? get labTestFasting => _labTestFasting;
  List<String> get chronicDiseases => _chronicDiseases;
  int get averageCycleLength => _averageCycleLength;
  int get averagePeriodLength => _averagePeriodLength;
  bool get isCycleLengthUnknown => _isCycleLengthUnknown;
  DateTime? get lastPeriodDate => _lastPeriodDate;
  MenopauseStatus get menopauseStatus => _menopauseStatus;
  String? get birthControlMethod => _birthControlMethod;
  List<String> get womenDiseases => _womenDiseases;
  List<String> get knownDiseases =>
      {..._chronicDiseases, ..._womenDiseases}.toList(growable: false);
  List<MedicationIdentity> get dailyMedications => _dailyMedications;
  List<String> get dailySupplements => _dailySupplements;

  // ── Setter'lar ────────────────────────────────────────
  // NOT: TextField setter'larında notifyListeners() çağırmıyoruz.
  // Her karakter girişinde tüm widget ağacını yeniden çizmek gereksiz kasma yapar.
  // Bu değerler sadece kaydederken (saveAndComplete) veya summary sayfasında kullanılır.

  void setUserName(String value) {
    _userName = value;
    // notifyListeners() kaldırıldı — TextField kendi state'ini yönetir
  }

  void setIsSmoker(bool value) {
    _isSmoker = value;
    if (!value) _smokingYears = 0;
    notifyListeners(); // UI gösterimi değişir (conditional widget)
  }

  void setSmokingYears(int value) {
    _smokingYears = value;
    // notifyListeners() kaldırıldı — TextField kendi state'ini yönetir
  }

  void setWeight(double? value) {
    _weight = value;
    // notifyListeners() kaldırıldı — TextField kendi state'ini yönetir
  }

  void setHeight(double? value) {
    _height = value;
    // notifyListeners() kaldırıldı — TextField kendi state'ini yönetir
  }

  void setAge(int? value) {
    _age = value;
    // notifyListeners() kaldırıldı — TextField kendi state'ini yönetir
  }

  void setBirthDate(DateTime? value) {
    _birthDate = value;
    if (value == null) {
      _age = null;
    } else {
      final today = DateTime.now();
      var years = today.year - value.year;
      if (today.month < value.month ||
          today.month == value.month && today.day < value.day) {
        years--;
      }
      _age = years < 0 ? null : years;
    }
    notifyListeners();
  }

  void setRelationshipStatus(String value) {
    _relationshipStatus = value;
    notifyListeners(); // Seçim UI'da gösterilir
  }

  void setSexuallyActive(bool? value) {
    _sexuallyActive = value;
    notifyListeners();
  }

  void setWantsChildrenInYear(bool? value) {
    _wantsChildrenInYear = value;
    notifyListeners();
  }

  void setLabResults(Map<String, LabResult> value) {
    _labResults = Map<String, LabResult>.from(value);
  }

  void setLabTestDate(DateTime? value) {
    _labTestDate = value;
  }

  void setLabTestFasting(bool? value) {
    _labTestFasting = value;
    // notifyListeners() kaldırıldı — TextField kendi state'ini yönetir
  }

  void toggleChronicDisease(String disease) {
    final existingIndex = _chronicDiseases.indexWhere(
      (value) => AppStrings.localizeStoredValue(value) == disease,
    );
    if (existingIndex >= 0) {
      _chronicDiseases = List.from(_chronicDiseases)..removeAt(existingIndex);
    } else {
      _chronicDiseases = List.from(_chronicDiseases)..add(disease);
    }
    notifyListeners();
  }

  void addChronicDisease(String disease) {
    final value = disease.trim();
    if (value.isEmpty || _containsCondition(_chronicDiseases, value)) return;
    _chronicDiseases = [..._chronicDiseases, value];
    notifyListeners();
  }

  void setAverageCycleLength(int value) {
    _averageCycleLength = CycleRules.sanitizeCycleLength(value);
    notifyListeners(); // Slider label güncellenmeli
  }

  void setAveragePeriodLength(int value) {
    _averagePeriodLength = CycleRules.sanitizePeriodLength(value);
    notifyListeners();
  }

  void setIsCycleLengthUnknown(bool value) {
    _isCycleLengthUnknown = value;
    if (value) {
      _averageCycleLength = CycleRules.defaultCycleLength;
    }
    notifyListeners(); // Conditional widget gösterir/gizler
  }

  void setLastPeriodDate(DateTime? value) {
    _lastPeriodDate = value;
    notifyListeners(); // Tarih gösterimini güncelle
  }

  void setMenopauseStatus(MenopauseStatus value) {
    _menopauseStatus = value;
    notifyListeners();
  }

  void setBirthControlMethod(String? value) {
    _birthControlMethod = value;
    notifyListeners();
  }

  void toggleWomenDisease(String disease) {
    final existingIndex = _womenDiseases.indexWhere(
      (value) => AppStrings.localizeStoredValue(value) == disease,
    );
    if (existingIndex >= 0) {
      _womenDiseases = List.from(_womenDiseases)..removeAt(existingIndex);
    } else {
      _womenDiseases = List.from(_womenDiseases)..add(disease);
    }
    notifyListeners();
  }

  void addWomenDisease(String disease) {
    final value = disease.trim();
    if (value.isEmpty || _containsCondition(_womenDiseases, value)) return;
    _womenDiseases = [..._womenDiseases, value];
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
    _chronicDiseases = diseases;
    _womenDiseases = [];
    notifyListeners();
  }

  void addKnownDisease(String disease) {
    final value = disease.trim();
    if (value.isEmpty || _containsCondition(knownDiseases, value)) return;
    _chronicDiseases = [...knownDiseases, value];
    _womenDiseases = [];
    notifyListeners();
  }

  bool _containsCondition(List<String> values, String candidate) => values.any(
    (value) =>
        AppStrings.localizeStoredValue(value).trim().toLowerCase() ==
        candidate.toLowerCase(),
  );

  void addMedication(MedicationIdentity medication) {
    if (!_dailyMedications.contains(medication)) {
      _dailyMedications = List.from(_dailyMedications)..add(medication);
      notifyListeners();
    }
  }

  void removeMedication(MedicationIdentity medication) {
    _dailyMedications = List.from(_dailyMedications)..remove(medication);
    notifyListeners();
  }

  void addSupplement(String name) {
    if (name.isNotEmpty && !_dailySupplements.contains(name)) {
      _dailySupplements = List.from(_dailySupplements)..add(name);
      notifyListeners();
    }
  }

  void removeSupplement(String name) {
    _dailySupplements = List.from(_dailySupplements)..remove(name);
    notifyListeners();
  }

  // ── Sayfa Navigasyonu ─────────────────────────────────
  void nextPage() {
    if (_currentPage < totalPages - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  void goToPage(int page) {
    if (_currentPage != page) {
      _currentPage = page;
      notifyListeners();
    }
  }

  bool get canGoNext => _currentPage < totalPages - 1;
  bool get canGoBack => _currentPage > 0;

  // ── Kaydet & Tamamla ──────────────────────────────────
  Future<bool> saveAndComplete() async {
    _isSaving = true;
    notifyListeners();

    final settings = UserSettings(
      userName: _userName,
      isOnboardingComplete: true,
      isSmoker: _isSmoker,
      smokingYears: _isSmoker ? _smokingYears : null,
      weight: _weight,
      height: _height,
      age: _age,
      relationshipStatus: _relationshipStatus,
      sexuallyActive: _sexuallyActive,
      wantsChildrenInYear: null,
      labResults: _labResults,
      labTestDate: _labTestDate,
      labTestFasting: _labTestFasting,
      chronicDiseases: knownDiseases,
      averageCycleLength: _averageCycleLength,
      averagePeriodLength: _averagePeriodLength,
      lastPeriodDate: _lastPeriodDate,
      menopauseStatus: _menopauseStatus,
      birthControlMethod: _birthControlMethod,
      womenDiseases: const [],
      dailyMedications: _dailyMedications,
      dailySupplements: _dailySupplements,
    );

    final success = await _storage.saveSettings(settings);

    // Yeni hesap için boş/eksik profil yedeği oluşturma. Bulut yedeği ancak
    // onboarding verileri başarıyla yerelde tamamlandıktan sonra başlatılır.
    if (success && _storage.isUserLoggedIn) {
      await _sync.backupToCloud();
    }

    _isSaving = false;
    notifyListeners();

    return success;
  }
}
