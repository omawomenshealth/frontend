import 'package:app_proje_a/data/services/local_storage_service.dart';

import '../domain/models/daily_log.dart';
import '../domain/repositories/tracking_repository.dart';

/// Adapter for the existing encrypted local store. No schema migration is
/// needed: DailyLog.toJson/fromJson remain unchanged.
final class LocalTrackingRepository implements TrackingRepository {
  LocalTrackingRepository(this._storage);

  final LocalStorageService _storage;

  @override
  Future<bool> save(DailyLog log) => _storage.saveDailyLog(log);

  @override
  Future<bool> deletePeriodForDate(DateTime date) =>
      _storage.deletePeriodLogsForDate(date);

  @override
  List<DailyLog> logsForDate(DateTime date) => _storage.loadLogsForDate(date);

  @override
  List<DailyLog> logsForMonth(int year, int month) =>
      _storage.loadLogsForMonth(year, month);

  @override
  List<DailyLog> allLogs() => _storage.loadAllLogs();
}
