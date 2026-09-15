import 'package:app_proje_a/core/utils/date_extensions.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/features/tracking/application/tracking_controller.dart';
import 'package:app_proje_a/features/tracking/data/local_tracking_repository.dart';
import 'package:app_proje_a/features/tracking/domain/models/daily_log.dart';
import 'package:app_proje_a/features/tracking/domain/models/tracking_section.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<LocalStorageService> _storage() async {
  SharedPreferences.setMockInitialValues({});
  final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
  await storage.init();
  await storage.saveSettings(
    UserSettings(
      isOnboardingComplete: true,
      lastPeriodDate: DateTime.now().subtract(const Duration(days: 8)),
    ),
  );
  return storage;
}

void main() {
  test('tracking sections map to observed sections without changing JSON', () {
    expect(
      TrackingSection.symptoms.observedSection,
      DailyLogObservedSection.symptom,
    );
    expect(
      TrackingSection.medication.observedSection,
      DailyLogObservedSection.medication,
    );
    expect(TrackingSection.fromTabIndex(5), TrackingSection.skincare);
  });

  test('opening a section reuses its existing daily log', () async {
    final storage = await _storage();
    final now = DateTime.now();
    await storage.saveDailyLog(
      DailyLog(
        date: now,
        waterIntakeMl: 500,
        observedSections: const {DailyLogObservedSection.nutrition},
      ),
    );

    final tracking = TrackingController.local(storage);
    addTearDown(tracking.dispose);
    final reopened = tracking.initialLogForSection(
      TrackingSection.nutrition,
      now,
    );

    expect(reopened.date, now);
    expect(reopened.waterIntakeMl, 500);
  });

  test(
    'saving a log exposes a revision and preserves the encrypted log',
    () async {
      final storage = await _storage();
      final tracking = TrackingController.local(storage);
      addTearDown(tracking.dispose);
      var notifications = 0;
      tracking.addListener(() => notifications++);
      final log = DailyLog(
        date: DateTime.now(),
        mood: 'İyi',
        observedSections: const {DailyLogObservedSection.wellbeing},
      );

      expect(await tracking.saveLog(log), isTrue);
      expect(tracking.revision, 1);
      expect(notifications, 1);
      expect(storage.loadLogsForDate(log.date).single.mood, 'İyi');
    },
  );

  test('deleting period keeps the same day nutrition log', () async {
    final storage = await _storage();
    final day = DateTime.now().dateOnly;
    await storage.saveDailyLog(
      DailyLog(
        date: day,
        hasExplicitTime: false,
        flowIntensity: 'Hafif',
        waterIntakeMl: 250,
        observedSections: const {
          DailyLogObservedSection.period,
          DailyLogObservedSection.nutrition,
        },
      ),
    );
    final tracking = TrackingController.local(storage);
    addTearDown(tracking.dispose);

    expect(await tracking.deletePeriodForDate(day), isTrue);
    final remaining = storage.loadLogsForDate(day).single;
    expect(remaining.flowIntensity, isNull);
    expect(remaining.waterIntakeMl, 250);
    expect(
      remaining.observedSections,
      contains(DailyLogObservedSection.nutrition),
    );
    expect(
      remaining.observedSections,
      isNot(contains(DailyLogObservedSection.period)),
    );
  });

  test('future log is rejected without revision change', () async {
    final storage = await _storage();
    final tracking = TrackingController.local(storage);
    addTearDown(tracking.dispose);

    expect(
      await tracking.saveLog(
        DailyLog.empty(DateTime.now().add(const Duration(days: 1))),
      ),
      isFalse,
    );
    expect(tracking.revision, 0);
  });

  test('multi-day period edit is one tracking revision', () async {
    final storage = await _storage();
    final today = DateTime.now().dateOnly;
    final yesterday = today.subtract(const Duration(days: 1));
    await storage.saveDailyLog(
      DailyLog(
        date: yesterday,
        hasExplicitTime: false,
        waterIntakeMl: 250,
        observedSections: const {DailyLogObservedSection.nutrition},
      ),
    );
    final tracking = TrackingController.local(storage);
    addTearDown(tracking.dispose);

    expect(
      await tracking.applyPeriodDayChanges({
        yesterday: true,
        today: true,
        today.add(const Duration(days: 1)): true,
      }),
      isTrue,
    );
    expect(tracking.revision, 1);
    expect(storage.loadLogsForDate(yesterday).single.waterIntakeMl, 250);
    expect(storage.loadLogsForDate(yesterday).single.flowIntensity, isNotNull);
    expect(storage.loadLogsForDate(today).single.flowIntensity, isNotNull);
    expect(
      storage.loadLogsForDate(today.add(const Duration(days: 1))),
      isEmpty,
    );
  });

  test(
    'repository reads the existing month without schema conversion',
    () async {
      final storage = await _storage();
      final repository = LocalTrackingRepository(storage);
      final now = DateTime.now();
      await repository.save(
        DailyLog(
          date: now,
          skincare: const ['Niasinamid'],
          observedSections: const {DailyLogObservedSection.skincare},
        ),
      );

      expect(repository.logsForMonth(now.year, now.month), hasLength(1));
      expect(repository.allLogs().single.skincare, ['Niasinamid']);
    },
  );
}
