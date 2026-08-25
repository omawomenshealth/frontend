import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/cycle_rules.dart';
import '../../../data/models/lab_result_model.dart';
import '../../../data/models/medication_identity_model.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/sync_service.dart';

/// Onboarding iş mantığı — adım adım kullanıcı bilgisi toplama.
class OnboardingViewModel extends ChangeNotifier {
  // Dependencies
  final LocalStorageService _storage;
  final SyncService _sync;

  OnboardingViewModel(this._storage, this._sync);

  // Navigation state
  static const detailStepCount = 4;

  int _currentPage = 0;
  int _detailStep = 0;
  bool _detailForward = true;

  // Form state: personal
  String _userName = '';
  int? _age;
  DateTime? _birthDate;
  double? _weight;
  double? _height;

  // Form state: lifestyle
  bool _isSmoker = false;
  int _smokingYears = 0;

  // Form state: relationship
  String _relationshipStatus = AppStrings.relationshipStatusOptions.last;
  bool? _sexuallyActive;
  bool? _wantsChildrenInYear;

  // Form state: health
  Map<String, LabResult> _labResults = {};
  DateTime? _labTestDate;
  bool? _labTestFasting;
  List<String> _chronicDiseases = [];

  // Form state: women's health
  int _averageCycleLength = CycleRules.defaultCycleLength;
  int _averagePeriodLength = CycleRules.defaultPeriodLength;
  bool _isCycleLengthUnknown = false;
  DateTime? _lastPeriodDate;
  List<DateTime> _lastPeriodDays = [];
  MenopauseStatus _menopauseStatus = MenopauseStatus.none;
  String? _birthControlMethod;
  List<String> _womenDiseases = [];
  final List<String> _customConditions = [];
  final List<String> _customBirthControlMethods = [];

  // Form state: medications
  List<MedicationIdentity> _dailyMedications = [];
  List<String> _dailySupplements = [];

  // Persistence state
  bool _isSaving = false;

  // Getters: navigation
  int get currentPage => _currentPage;
  int get totalPages => 4;
  bool get canGoNext => _currentPage < totalPages - 1;
  bool get canGoBack => _currentPage > 0;
  bool get isDetailedHealthPage => _currentPage == totalPages - 1;

  int get detailStep => _detailStep;
  bool get detailForward => _detailForward;
  bool get isFirstDetailStep => _detailStep == 0;
  bool get isLastDetailStep => _detailStep == detailStepCount - 1;

  // Getters: form
  String get userName => _userName;
  int? get age => _age;
  DateTime? get birthDate => _birthDate;
  double? get weight => _weight;
  double? get height => _height;

  bool get isSmoker => _isSmoker;
  int get smokingYears => _smokingYears;

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
  List<DateTime> get lastPeriodDays => List.unmodifiable(_lastPeriodDays);
  MenopauseStatus get menopauseStatus => _menopauseStatus;
  String? get birthControlMethod => _birthControlMethod;
  List<String> get womenDiseases => _womenDiseases;
  List<String> get customConditions => _customConditions;
  List<String> get customBirthControlMethods => _customBirthControlMethods;

  List<MedicationIdentity> get dailyMedications => _dailyMedications;
  List<String> get dailySupplements => _dailySupplements;

  // Getters: computed
  bool get isSaving => _isSaving;
  List<String> get knownDiseases =>
      {..._chronicDiseases, ..._womenDiseases}.toList(growable: false);

  // Navigation actions
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

  void nextDetailStep() {
    if (isLastDetailStep) return;
    _detailForward = true;
    _detailStep++;
    notifyListeners();
  }

  void previousDetailStep() {
    if (isFirstDetailStep) return;
    _detailForward = false;
    _detailStep--;
    notifyListeners();
  }

  // Personal actions
  void setUserName(String value) {
    _userName = value;
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

  void setWeight(double? value) {
    _weight = value;
  }

  void setHeight(double? value) {
    _height = value;
  }

  void setAge(int? value) {
    _age = value;
  }

  // Lifestyle actions
  void setIsSmoker(bool value) {
    _isSmoker = value;
    if (!value) _smokingYears = 0;
    notifyListeners();
  }

  void setSmokingYears(int value) {
    _smokingYears = value;
  }

  // Relationship actions
  void setRelationshipStatus(String value) {
    _relationshipStatus = value;
    notifyListeners();
  }

  void setSexuallyActive(bool? value) {
    _sexuallyActive = value;
    notifyListeners();
  }

  void setWantsChildrenInYear(bool? value) {
    _wantsChildrenInYear = value;
    notifyListeners();
  }

  // Lab actions
  void setLabData({
    required Map<String, LabResult> results,
    DateTime? testDate,
    bool? fasting,
  }) {
    _labResults = Map<String, LabResult>.from(results);
    _labTestDate = testDate;
    _labTestFasting = fasting;
  }

  void setLabResults(Map<String, LabResult> value) {
    _labResults = Map<String, LabResult>.from(value);
  }

  void setLabTestDate(DateTime? value) {
    _labTestDate = value;
  }

  void setLabTestFasting(bool? value) {
    _labTestFasting = value;
  }

  // Disease actions
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
    final value = _rememberCustomValue(_customConditions, disease);
    if (value.isEmpty || _containsCondition(_chronicDiseases, value)) return;
    _chronicDiseases = [..._chronicDiseases, value];
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
    final value = _rememberCustomValue(_customConditions, disease);
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
    final value = _rememberCustomValue(_customConditions, disease);
    if (value.isEmpty || _containsCondition(knownDiseases, value)) return;
    _chronicDiseases = [...knownDiseases, value];
    _womenDiseases = [];
    notifyListeners();
  }

  // Cycle actions
  void setAverageCycleLength(int value) {
    _averageCycleLength = CycleRules.sanitizeCycleLength(value);
    notifyListeners();
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
    notifyListeners();
  }

  void setLastPeriodDate(DateTime? value) {
    setLastPeriodDays(value == null ? const [] : [value]);
  }

  void setLastPeriodDays(Iterable<DateTime> values) {
    final today = DateTime.now();
    final days =
        values
            .map((value) => DateTime(value.year, value.month, value.day))
            .where((value) => !value.isAfter(today))
            .toSet()
            .toList()
          ..sort();
    _lastPeriodDays = days.take(CycleRules.maxPeriodLength).toList();
    _lastPeriodDate = _lastPeriodDays.isEmpty ? null : _lastPeriodDays.first;
    if (_lastPeriodDays.isNotEmpty) {
      _averagePeriodLength = CycleRules.sanitizePeriodLength(
        _lastPeriodDays.length,
      );
    }
    notifyListeners();
  }

  void setMenopauseStatus(MenopauseStatus value) {
    _menopauseStatus = value;
    notifyListeners();
  }

  void setBirthControlMethod(String? value) {
    _birthControlMethod = value;
    notifyListeners();
  }

  void addBirthControlMethod(String method) {
    final value = _rememberCustomValue(_customBirthControlMethods, method);
    if (value.isEmpty) return;
    _birthControlMethod = value;
    notifyListeners();
  }

  // Medication actions
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

  // Private disease helpers
  bool _containsCondition(List<String> values, String candidate) => values.any(
    (value) =>
        _normalizeCustomValue(AppStrings.localizeStoredValue(value)) ==
        _normalizeCustomValue(candidate),
  );

  String _rememberCustomValue(List<String> values, String rawValue) {
    final cleaned = rawValue.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleaned.isEmpty) return '';

    final normalized = _normalizeCustomValue(cleaned);
    for (final value in values) {
      if (_normalizeCustomValue(value) == normalized) return value;
    }

    values.add(cleaned);
    return cleaned;
  }

  String _normalizeCustomValue(String value) => value
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll(RegExp('[İIı]'), 'i')
      .toLowerCase();

  // Persistence
  Future<bool> saveAndComplete() async {
    _isSaving = true;
    notifyListeners();

    var success = await _storage.saveSettings(_buildSettings());

    if (success) {
      for (final day in _lastPeriodDays) {
        final saved = await _storage.saveDailyLog(
          DailyLog(
            date: day,
            hasExplicitTime: false,
            flowIntensity: AppStrings.flowOptions[1],
            observedSections: const {DailyLogObservedSection.period},
          ),
        );
        if (!saved) success = false;
      }
    }

    if (success && _storage.isUserLoggedIn) {
      await _sync.backupToCloud();
    }

    _isSaving = false;
    notifyListeners();

    return success;
  }

  UserSettings _buildSettings() {
    return UserSettings(
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
      customConditions: _customConditions,
      customBirthControlMethods: _customBirthControlMethods,
    );
  }
}
