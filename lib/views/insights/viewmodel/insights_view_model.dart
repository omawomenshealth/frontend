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
  int _loggedDayCount = 0;

  List<PersonalInsight> get insights => _insights;
  bool get isLoading => _isLoading;
  int get loggedDayCount => _loggedDayCount;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    final logs = _storage.loadAllLogs();
    final doseRecords = _storage.loadMedicationDoseRecords();
    final settings = _storage.loadSettings();
    _loggedDayCount = logs
        .map((log) => DateUtils.dateOnly(log.date))
        .toSet()
        .length;
    _insights = _engine.generate(
      logs,
      doseRecords: doseRecords,
      settings: settings,
    );

    _isLoading = false;
    notifyListeners();
  }
}
