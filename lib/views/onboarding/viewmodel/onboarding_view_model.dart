import 'package:flutter/material.dart';
import '../../../data/models/user_settings_model.dart';
import '../../../data/services/local_storage_service.dart';

/// Onboarding iş mantığı — adım adım kullanıcı bilgisi toplama.
class OnboardingViewModel extends ChangeNotifier {
  final LocalStorageService _storage;

  OnboardingViewModel(this._storage);

  // ── Sayfa kontrolü ────────────────────────────────────
  int _currentPage = 0;
  int get currentPage => _currentPage;

  // Toplam sayfa sayısı cinsiyete göre değişir
  int get totalPages => 4;

  // ── Form verileri ─────────────────────────────────────
  String _userName = '';
  Gender _gender = Gender.female;
  bool _isSmoker = false;
  int _smokingYears = 0;
  double? _weight;
  double? _height;
  int? _age;
  String _relationshipStatus = 'Belirtmek istemiyorum';
  bool? _sexuallyActive;
  bool? _wantsChildrenInYear;
  String? _bloodTestResults;
  List<String> _chronicDiseases = [];

  // Kadın
  int _averageCycleLength = 28;
  int _averagePeriodLength = 5;
  bool _isCycleLengthUnknown = false;
  DateTime? _lastPeriodDate;
  MenopauseStatus _menopauseStatus = MenopauseStatus.none;
  String? _birthControlMethod;
  List<String> _womenDiseases = [];

  // Erkek
  bool? _andropauseStatus;
  List<String> _menDiseases = [];

  // İlaç & Takviye
  List<String> _dailyMedications = [];
  List<String> _dailySupplements = [];

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  // ── Getter'lar ────────────────────────────────────────
  String get userName => _userName;
  Gender get gender => _gender;
  bool get isSmoker => _isSmoker;
  int get smokingYears => _smokingYears;
  double? get weight => _weight;
  double? get height => _height;
  int? get age => _age;
  String get relationshipStatus => _relationshipStatus;
  bool? get sexuallyActive => _sexuallyActive;
  bool? get wantsChildrenInYear => _wantsChildrenInYear;
  String? get bloodTestResults => _bloodTestResults;
  List<String> get chronicDiseases => _chronicDiseases;
  int get averageCycleLength => _averageCycleLength;
  int get averagePeriodLength => _averagePeriodLength;
  bool get isCycleLengthUnknown => _isCycleLengthUnknown;
  DateTime? get lastPeriodDate => _lastPeriodDate;
  MenopauseStatus get menopauseStatus => _menopauseStatus;
  String? get birthControlMethod => _birthControlMethod;
  List<String> get womenDiseases => _womenDiseases;
  bool? get andropauseStatus => _andropauseStatus;
  List<String> get menDiseases => _menDiseases;
  List<String> get dailyMedications => _dailyMedications;
  List<String> get dailySupplements => _dailySupplements;

  // ── Setter'lar ────────────────────────────────────────
  void setUserName(String value) {
    _userName = value;
    notifyListeners();
  }

  void setGender(Gender value) {
    _gender = value;
    notifyListeners();
  }

  void setIsSmoker(bool value) {
    _isSmoker = value;
    if (!value) _smokingYears = 0;
    notifyListeners();
  }

  void setSmokingYears(int value) {
    _smokingYears = value;
    notifyListeners();
  }

  void setWeight(double? value) {
    _weight = value;
    notifyListeners();
  }

  void setHeight(double? value) {
    _height = value;
    notifyListeners();
  }

  void setAge(int? value) {
    _age = value;
    notifyListeners();
  }

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

  void setBloodTestResults(String? value) {
    _bloodTestResults = value;
    notifyListeners();
  }

  void toggleChronicDisease(String disease) {
    if (_chronicDiseases.contains(disease)) {
      _chronicDiseases = List.from(_chronicDiseases)..remove(disease);
    } else {
      _chronicDiseases = List.from(_chronicDiseases)..add(disease);
    }
    notifyListeners();
  }

  void setAverageCycleLength(int value) {
    _averageCycleLength = value;
    notifyListeners();
  }

  void setAveragePeriodLength(int value) {
    _averagePeriodLength = value;
    notifyListeners();
  }

  void setIsCycleLengthUnknown(bool value) {
    _isCycleLengthUnknown = value;
    if (value) {
      _averageCycleLength = 28; // Bilinmiyorsa varsayılan 28 olarak kalır
    }
    notifyListeners();
  }

  void setLastPeriodDate(DateTime? value) {
    _lastPeriodDate = value;
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

  void toggleWomenDisease(String disease) {
    if (_womenDiseases.contains(disease)) {
      _womenDiseases = List.from(_womenDiseases)..remove(disease);
    } else {
      _womenDiseases = List.from(_womenDiseases)..add(disease);
    }
    notifyListeners();
  }

  void setAndropauseStatus(bool? value) {
    _andropauseStatus = value;
    notifyListeners();
  }

  void toggleMenDisease(String disease) {
    if (_menDiseases.contains(disease)) {
      _menDiseases = List.from(_menDiseases)..remove(disease);
    } else {
      _menDiseases = List.from(_menDiseases)..add(disease);
    }
    notifyListeners();
  }

  void addMedication(String name) {
    if (name.isNotEmpty && !_dailyMedications.contains(name)) {
      _dailyMedications = List.from(_dailyMedications)..add(name);
      notifyListeners();
    }
  }

  void removeMedication(String name) {
    _dailyMedications = List.from(_dailyMedications)..remove(name);
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
    _currentPage = page;
    notifyListeners();
  }

  bool get canGoNext => _currentPage < totalPages - 1;
  bool get canGoBack => _currentPage > 0;

  // ── Kaydet & Tamamla ──────────────────────────────────
  Future<bool> saveAndComplete() async {
    _isSaving = true;
    notifyListeners();

    final settings = UserSettings(
      userName: _userName,
      gender: _gender,
      isOnboardingComplete: true,
      isSmoker: _isSmoker,
      smokingYears: _isSmoker ? _smokingYears : null,
      weight: _weight,
      height: _height,
      age: _age,
      relationshipStatus: _relationshipStatus,
      sexuallyActive: _sexuallyActive,
      wantsChildrenInYear: _wantsChildrenInYear,
      bloodTestResults: _bloodTestResults,
      chronicDiseases: _chronicDiseases,
      averageCycleLength: _averageCycleLength,
      averagePeriodLength: _averagePeriodLength,
      lastPeriodDate: _lastPeriodDate,
      menopauseStatus: _menopauseStatus,
      birthControlMethod: _birthControlMethod,
      womenDiseases: _womenDiseases,
      andropauseStatus: _andropauseStatus,
      menDiseases: _menDiseases,
      dailyMedications: _dailyMedications,
      dailySupplements: _dailySupplements,
    );

    final success = await _storage.saveSettings(settings);

    _isSaving = false;
    notifyListeners();

    return success;
  }
}
