import 'package:flutter/material.dart';

import '../../../core/utils/personal_insight_engine.dart';
import '../../../data/models/personal_insight_model.dart';
import '../../../data/services/local_storage_service.dart';

class InsightsViewModel extends ChangeNotifier {
  final LocalStorageService _storage;
  final PersonalInsightEngine _engine = const PersonalInsightEngine();

  InsightsViewModel(this._storage);

  List<PersonalInsight> _insights = const [];
  bool _isLoading = false;

  List<PersonalInsight> get insights => _insights;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    final logs = _storage.loadAllLogs();
    final doseRecords = _storage.loadMedicationDoseRecords();
    final settings = _storage.loadSettings();
    _insights = _engine
        .generate(logs, doseRecords: doseRecords, settings: settings)
        .where(
          (insight) =>
              insight.kind != PersonalInsightKind.dataBuilding &&
              insight.kind != PersonalInsightKind.recordingSummary &&
              insight.kind != PersonalInsightKind.frequentMood &&
              insight.kind != PersonalInsightKind.recurringSymptom &&
              insight.kind != PersonalInsightKind.frequentActivity &&
              insight.kind != PersonalInsightKind.frequentNutrition &&
              insight.kind != PersonalInsightKind.frequentBowel,
        )
        .toList(growable: false);

    _isLoading = false;
    notifyListeners();
  }
}
