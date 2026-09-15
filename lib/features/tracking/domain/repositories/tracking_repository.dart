import '../models/daily_log.dart';

/// Reading and writing logs without exposing the storage implementation to
/// dashboard, calendar, insights or article recommendation code.
abstract interface class TrackingRepository {
  Future<bool> save(DailyLog log);
  Future<bool> deletePeriodForDate(DateTime date);
  List<DailyLog> logsForDate(DateTime date);
  List<DailyLog> logsForMonth(int year, int month);
  List<DailyLog> allLogs();
}
