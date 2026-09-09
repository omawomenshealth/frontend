import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/cycle_rules.dart';
import '../../../data/models/period_log_model.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/sync_service.dart';

/// Onboarding iş mantığı — adım adım kullanıcı bilgisi toplama.
class OnboardingViewModel extends ChangeNotifier {
  // ===========================================================================
  // Dependencies
  // ===========================================================================

  final LocalStorageService _storage;
  final SyncService _sync;

  OnboardingViewModel(this._storage, this._sync);

  // ===========================================================================
  // Navigation
  // ===========================================================================

  static const detailStepCount = 1;

  int _currentPage = 0;

  int get currentPage => _currentPage;
  int get totalPages => 5;
  bool get canGoNext => _currentPage < totalPages - 1;
  bool get canGoBack => _currentPage > 0;
  bool get isPreviewPage => _currentPage == totalPages - 1;

  void nextPage() {
    if (!canGoNext) return;

    _currentPage++;
    notifyListeners();
  }

  void previousPage() {
    if (!canGoBack) return;

    _currentPage--;
    notifyListeners();
  }

  void goToPage(int page) {
    if (_currentPage == page) return;

    _currentPage = page;
    notifyListeners();
  }

  // ===========================================================================
  // Personal
  // ===========================================================================

  // State

  String _userName = '';
  int? _age;
  DateTime? _birthDate;

  // Getters

  String get userName => _userName;
  int? get age => _age;
  DateTime? get birthDate => _birthDate;

  // Setters / Actions

  void setUserName(String value) {
    _userName = value;
    notifyListeners();
  }

  void setBirthDate(DateTime? value) {
    _birthDate = value;

    if (value == null) {
      _age = null;
    } else {
      final today = DateTime.now();
      var years = today.year - value.year;

      if (today.month < value.month ||
          (today.month == value.month && today.day < value.day)) {
        years--;
      }

      _age = years < 0 ? null : years;
    }

    notifyListeners();
  }

  void setAge(int? value) {
    _age = value;
    notifyListeners();
  }

  // ===========================================================================
  // Wellbeing
  // ===========================================================================

  // State

  Set<String> _moods = {};
  Set<String> _supportNeeds = {};

  // Getters

  Set<String> get moods => Set.unmodifiable(_moods);
  Set<String> get supportNeeds => Set.unmodifiable(_supportNeeds);

  // Setters / Actions

  void setMoods(Set<String> values) {
    _moods = Set<String>.from(values);
    notifyListeners();
  }

  void setSupportNeeds(Set<String> values) {
    _supportNeeds = Set<String>.from(values);
    notifyListeners();
  }

  // ===========================================================================
  // Health
  // ===========================================================================

  // State

  double? _weight;
  double? _height;
  SmokingStatus? _smokingStatus;
  List<String> _conditions = [];
  final List<String> _customConditions = [];

  // Getters

  double? get weight => _weight;
  double? get height => _height;
  SmokingStatus? get smokingStatus => _smokingStatus;

  List<String> get chronicDiseases =>
      List.unmodifiable(_conditions);

  List<String> get womenDiseases =>
      List.unmodifiable(_conditions);

  List<String> get customConditions =>
      List.unmodifiable(_customConditions);

  List<String> get knownDiseases =>
      List.unmodifiable(_conditions);

  // Setters / Actions

  void setWeight(double? value) {
    _weight = value;
    notifyListeners();
  }

  void setHeight(double? value) {
    _height = value;
    notifyListeners();
  }

  void setSmokingStatus(SmokingStatus? value) {
    _smokingStatus = value;
    notifyListeners();
  }

  void toggleChronicDisease(String disease) {
    final existingIndex = _conditions.indexWhere(
      (value) => AppStrings.localizeStoredValue(value) == disease,
    );

    if (existingIndex >= 0) {
      _conditions = List.from(_conditions)..removeAt(existingIndex);
    } else {
      _conditions = List.from(_conditions)..add(disease);
    }

    notifyListeners();
  }

  void addChronicDisease(String disease) {
    final value = _rememberCustomValue(
      _customConditions,
      disease,
    );

    if (value.isEmpty || _containsCondition(_conditions, value)) {
      return;
    }

    _conditions = [..._conditions, value];
    notifyListeners();
  }

  void addWomenDisease(String disease) {
    addChronicDisease(disease);
  }

  void toggleKnownDisease(String disease) {
    final diseases = List<String>.from(knownDiseases);

    final existingIndex = diseases.indexWhere(
      (value) =>
          AppStrings.localizeStoredValue(value)
              .trim()
              .toLowerCase() ==
          disease.trim().toLowerCase(),
    );

    if (existingIndex >= 0) {
      diseases.removeAt(existingIndex);
    } else {
      diseases.add(disease);
    }

    _conditions = diseases;
    notifyListeners();
  }

  void addKnownDisease(String disease) {
    final value = _rememberCustomValue(
      _customConditions,
      disease,
    );

    if (value.isEmpty || _containsCondition(knownDiseases, value)) {
      return;
    }

    _conditions = [...knownDiseases, value];
    notifyListeners();
  }

  // ===========================================================================
  // Cycle
  // ===========================================================================

  // State

  int _averageCycleLength =
      CycleRules.defaultCycleLength;

  int _averagePeriodLength =
      CycleRules.defaultPeriodLength;

  DateTime? _lastPeriodDate;
  List<DateTime> _lastPeriodDays = [];

  MenopauseStatus? _menopauseStatus;

  String? _birthControlMethod;

  final List<String> _customBirthControlMethods = [];

  // Getters

  int get averageCycleLength => _averageCycleLength;
  int get averagePeriodLength => _averagePeriodLength;

  DateTime? get lastPeriodDate => _lastPeriodDate;

  List<DateTime> get lastPeriodDays =>
      List.unmodifiable(_lastPeriodDays);

  MenopauseStatus? get menopauseStatus =>
      _menopauseStatus;

  String? get birthControlMethod =>
      _birthControlMethod;

  List<String> get customBirthControlMethods =>
      List.unmodifiable(_customBirthControlMethods);

  // Setters / Actions

  void setAverageCycleLength(int value) {
    _averageCycleLength =
        CycleRules.sanitizeCycleLength(value);

    notifyListeners();
  }

  void setAveragePeriodLength(int value) {
    _averagePeriodLength =
        CycleRules.sanitizePeriodLength(value);

    notifyListeners();
  }

  void setLastPeriodDate(DateTime? value) {
    setLastPeriodDays(
      value == null ? const [] : [value],
    );
  }

  void setLastPeriodDays(Iterable<DateTime> values) {
    final today = DateTime.now();

    final days = values
        .map(
          (value) => DateTime(
            value.year,
            value.month,
            value.day,
          ),
        )
        .where((value) => !value.isAfter(today))
        .toSet()
        .toList()
      ..sort();

    _lastPeriodDays =
        days.take(CycleRules.maxPeriodLength).toList();

    _lastPeriodDate = _lastPeriodDays.isEmpty
        ? null
        : _lastPeriodDays.first;

    if (_lastPeriodDays.isNotEmpty) {
      _averagePeriodLength =
          CycleRules.sanitizePeriodLength(
        _lastPeriodDays.length,
      );
    }

    notifyListeners();
  }

  void setMenopauseStatus(MenopauseStatus? value) {
    _menopauseStatus = value;

    // Birth control is only applicable when
    // the user explicitly selects "none".
    if (value != MenopauseStatus.none) {
      _birthControlMethod = null;
    }

    notifyListeners();
  }

  void setBirthControlMethod(String? value) {
    _birthControlMethod = value;
    notifyListeners();
  }

  void addBirthControlMethod(String method) {
    final value = _rememberCustomValue(
      _customBirthControlMethods,
      method,
    );

    if (value.isEmpty) return;

    _birthControlMethod = value;
    notifyListeners();
  }

  // ===========================================================================
  // Persistence
  // ===========================================================================

  bool _isSaving = false;

  bool get isSaving => _isSaving;
  bool get isUserLoggedIn => _storage.isUserLoggedIn;

  Future<bool> saveAndComplete() async {
    _isSaving = true;
    notifyListeners();

    var success = await _storage.saveSettings(
      _buildSettings(),
    );

    if (success) {
      for (final day in _lastPeriodDays) {
        final saved = await _storage.saveDailyLog(
          DailyLog(
            date: day,
            hasExplicitTime: false,
            flowIntensity: AppStrings.flowOptions[1],
            observedSections: const {
              DailyLogObservedSection.period,
            },
          ),
        );

        if (!saved) {
          success = false;
        }
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
      smokingStatus: _smokingStatus,
      smokingYears: null,
      weight: _weight,
      height: _height,
      age: _age,
      chronicDiseases: knownDiseases,
      averageCycleLength: _averageCycleLength,
      averagePeriodLength: _averagePeriodLength,
      lastPeriodDate: _lastPeriodDate,
      menopauseStatus:
          _menopauseStatus ?? MenopauseStatus.none,
      birthControlMethod: _birthControlMethod,
      customConditions: _customConditions,
      customBirthControlMethods:
          _customBirthControlMethods,
    );
  }

  // ===========================================================================
  // Private Helpers
  // ===========================================================================

  bool _containsCondition(
    List<String> values,
    String candidate,
  ) {
    return values.any(
      (value) =>
          _normalizeCustomValue(
            AppStrings.localizeStoredValue(value),
          ) ==
          _normalizeCustomValue(candidate),
    );
  }

  String _rememberCustomValue(
    List<String> values,
    String rawValue,
  ) {
    final cleaned = rawValue
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ');

    if (cleaned.isEmpty) return '';

    final normalized =
        _normalizeCustomValue(cleaned);

    for (final value in values) {
      if (_normalizeCustomValue(value) == normalized) {
        return value;
      }
    }

    values.add(cleaned);
    return cleaned;
  }

  String _normalizeCustomValue(String value) {
    return value
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp('[İIı]'), 'i')
        .toLowerCase();
  }
}