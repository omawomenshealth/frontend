import 'package:flutter/foundation.dart';

import 'package:app_proje_a/application/cycle_prediction/cycle_prediction_coordinator.dart';
import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/utils/app_time.dart';
import 'package:app_proje_a/core/utils/date_extensions.dart';
import 'package:app_proje_a/core/utils/personal_insight_engine.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/notification_service.dart';
import 'package:app_proje_a/data/services/sync_service.dart';

import '../data/local_tracking_repository.dart';
import '../domain/models/daily_log.dart';
import '../domain/models/tracking_section.dart';
import '../domain/repositories/tracking_repository.dart';

/// Owns log selection and persistence. The dashboard and calendar may refresh
/// their own projections after a successful edit, but neither performs the
/// tracking write itself.
final class TrackingController extends ChangeNotifier {
  TrackingController({
    required TrackingRepository repository,
    required LocalStorageService storage,
    required CyclePredictionCoordinator cyclePredictions,
    NotificationService? notifications,
    SyncService? sync,
  }) : this._(
         repository,
         storage,
         cyclePredictions,
         notifications,
         sync,
         false,
       );

  TrackingController.local(
    LocalStorageService storage, {
    CyclePredictionCoordinator? cyclePredictions,
    NotificationService? notifications,
    SyncService? sync,
  }) : this._(
         LocalTrackingRepository(storage),
         storage,
         cyclePredictions ?? CyclePredictionCoordinator(storage),
         notifications,
         sync,
         cyclePredictions == null,
       );

  TrackingController._(
    this._repository,
    this._storage,
    this._cyclePredictions,
    this._notifications,
    this._sync,
    this._ownsCyclePredictions,
  );

  final TrackingRepository _repository;
  final LocalStorageService _storage;
  final CyclePredictionCoordinator _cyclePredictions;
  final NotificationService? _notifications;
  final SyncService? _sync;
  final bool _ownsCyclePredictions;
  final PersonalInsightEngine _insightEngine = const PersonalInsightEngine();

  int _revision = 0;
  int get revision => _revision;
  UserSettings? get settings =>
      _cyclePredictions.effectiveSettings ?? _storage.loadSettings();
  List<DailyLog> allLogs() => _repository.allLogs();
  List<DailyLog> logsForDate(DateTime date) => _repository.logsForDate(date);

  DailyLog initialLogForSection(TrackingSection section, DateTime date) {
    final logs = _repository.logsForDate(date);
    for (final log in logs) {
      if (log.observedSections.contains(section.observedSection)) return log;
      // Older versions sometimes stored supplements in their own section.
      if (section == TrackingSection.medication &&
          log.supplements.isNotEmpty &&
          (log.observedSections.contains(DailyLogObservedSection.supplement) ||
              log.observedSections.contains(
                DailyLogObservedSection.medication,
              ))) {
        return log;
      }
    }
    return DailyLog.empty(date.isToday ? AppTime.now : date.dateOnly);
  }

  Future<bool> saveLog(DailyLog log) async {
    final beforeIds = _notificationInsightIds(_storage.loadSettings());
    if (!await _repository.save(log)) return false;

    await _syncAfterWrite(deleted: false);
    await _cyclePredictions.refresh(force: true);
    await _notifyForNewInsight(beforeIds);
    _revision++;
    notifyListeners();
    return true;
  }

  Future<bool> deletePeriodForDate(DateTime date) async {
    if (!await _repository.deletePeriodForDate(date)) return false;

    // A deletion must replace the server snapshot; a merge could restore the
    // period-only entry that the user just removed.
    await _syncAfterWrite(deleted: true);
    await _cyclePredictions.refresh(force: true);
    _revision++;
    notifyListeners();
    return true;
  }

  /// Calendar's multi-day quick edit is one tracking operation. It writes
  /// every selected day locally, then performs a single cloud sync and cycle
  /// refresh rather than syncing after each day.
  Future<bool> applyPeriodDayChanges(
    Map<DateTime, bool> changes, {
    bool syncCloud = true,
  }) async {
    final today = AppTime.now.dateOnly;
    final normalized = <DateTime, bool>{};
    for (final entry in changes.entries) {
      final day = entry.key.dateOnly;
      if (!day.isAfter(today)) normalized[day] = entry.value;
    }
    if (normalized.isEmpty) return false;

    final days = normalized.keys.toList()..sort();
    var allSuccessful = true;
    var hasChanges = false;
    var hasDeletion = false;
    for (final day in days) {
      final shouldBeLogged = normalized[day]!;
      final logs = _repository.logsForDate(day);
      final hasPeriod = logs.any(
        (log) =>
            log.flowIntensity != null ||
            log.observedSections.contains(DailyLogObservedSection.period),
      );

      if (!shouldBeLogged) {
        if (!hasPeriod) continue;
        if (!await _repository.deletePeriodForDate(day)) {
          allSuccessful = false;
        } else {
          hasChanges = true;
          hasDeletion = true;
        }
        continue;
      }
      if (hasPeriod) continue;

      DailyLog? untimedLog;
      for (final log in logs) {
        if (log.date == day) {
          untimedLog = log;
          break;
        }
      }
      final base = untimedLog ?? DailyLog.empty(day);
      final quickPeriodLog = base.copyWith(
        date: day,
        hasExplicitTime: false,
        flowIntensity: AppStrings.flowOptions[1],
        observedSections: {
          ...base.observedSections,
          DailyLogObservedSection.period,
        },
      );
      if (!await _repository.save(quickPeriodLog)) {
        allSuccessful = false;
      } else {
        hasChanges = true;
      }
    }

    if (hasChanges) {
      if (syncCloud) await _syncAfterWrite(deleted: hasDeletion);
      await _cyclePredictions.refresh(force: true);
      _revision++;
      notifyListeners();
    }
    return allSuccessful;
  }

  Set<String> _notificationInsightIds(UserSettings? settings) => _insightEngine
      .generate(
        _repository.allLogs(),
        doseRecords: _storage.loadMedicationDoseRecords(),
        settings: settings,
      )
      .where((insight) => insight.shouldNotify)
      .map((insight) => insight.id)
      .toSet();

  Future<void> _syncAfterWrite({required bool deleted}) async {
    final sync = _sync;
    if (sync == null || !_storage.isUserLoggedIn) return;
    try {
      if (deleted) {
        await sync.backupToCloud();
      } else {
        await sync.mergeWithCloud();
      }
    } catch (error) {
      // The encrypted local save has already succeeded; a temporary cloud
      // failure must not be reported as a failed log edit.
      debugPrint('Tracking cloud sync failed after local save: $error');
    }
  }

  Future<void> _notifyForNewInsight(Set<String> beforeIds) async {
    final notifications = _notifications;
    final currentSettings = settings;
    if (notifications == null ||
        !notifications.isSupported ||
        currentSettings?.notificationsEnabled == false) {
      return;
    }

    final sentIds = _storage.loadNotifiedInsightIds();
    final candidates =
        _insightEngine
            .generate(
              _repository.allLogs(),
              doseRecords: _storage.loadMedicationDoseRecords(),
              settings: currentSettings,
            )
            .where(
              (insight) =>
                  insight.shouldNotify &&
                  !beforeIds.contains(insight.id) &&
                  !sentIds.contains(insight.id),
            )
            .toList()
          ..sort((left, right) {
            final urgency = right.notificationLevel.index.compareTo(
              left.notificationLevel.index,
            );
            if (urgency != 0) return urgency;
            return right.priority.compareTo(left.priority);
          });
    if (candidates.isEmpty) return;

    try {
      if (!await notifications.requestInsightPermissions()) return;
      final candidate = candidates.first;
      if (await notifications.scheduleInsightReady(insightId: candidate.id)) {
        await _storage.markInsightNotificationSent(candidate.id);
      }
    } catch (error) {
      debugPrint('Insight notification could not be scheduled: $error');
    }
  }

  @override
  void dispose() {
    if (_ownsCyclePredictions) _cyclePredictions.dispose();
    super.dispose();
  }
}
