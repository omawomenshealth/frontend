import 'package:app_proje_a/core/utils/app_time.dart';
import 'package:app_proje_a/core/utils/date_extensions.dart';
import 'package:app_proje_a/core/utils/period_calculator.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalStorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppTime.init(initialOffsetDays: -2);
    storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.saveSettings(
      UserSettings(
        isOnboardingComplete: true,
        averageCycleLength: 28,
        averagePeriodLength: 5,
      ),
    );
  });

  tearDown(() async {
    await AppTime.init(initialOffsetDays: 0);
  });

  test(
    'tamamlanan üç günlük adet uygulama yeniden açıldığında tahmini günceller',
    () async {
      final periodStart = AppTime.now.dateOnly;

      for (var day = 0; day < 3; day++) {
        await AppTime.setOffsetDays(-2 + day);
        await storage.saveDailyLog(
          DailyLog(
            date: periodStart
                .add(Duration(days: day))
                .add(const Duration(hours: 9)),
            flowIntensity: 'Orta',
            observedSections: const {DailyLogObservedSection.period},
          ),
        );
      }

      // Son kanama bugün girildiği için dönem henüz tamamlanmış sayılmaz.
      expect(storage.loadSettings()!.averagePeriodLength, 5);

      // Yeni kayıt eklemeden iki gün geçmesi, üç günlük dönemi tamamlar.
      await AppTime.setOffsetDays(2);
      final refreshed = await storage.refreshCycleStatistics();

      expect(refreshed!.averagePeriodLength, 3);
      expect(storage.loadSettings()!.averagePeriodLength, 3);

      final calculator = PeriodCalculator(
        lastPeriodDate: refreshed.lastPeriodDate!,
        cycleLength: refreshed.averageCycleLength,
        periodLength: refreshed.averagePeriodLength,
      );
      final nextPeriod = calculator.nextPeriodDate;

      expect(
        calculator.isInPeriod(nextPeriod.add(const Duration(days: 2))),
        isTrue,
      );
      expect(
        calculator.isInPeriod(nextPeriod.add(const Duration(days: 3))),
        isFalse,
      );
    },
  );

  test('tahmin tamamlanan adet sürelerinin ortalamasını kullanır', () async {
    await AppTime.setOffsetDays(-40);
    final firstPeriodStart = AppTime.now.dateOnly;

    for (var day = 0; day < 3; day++) {
      await AppTime.setOffsetDays(-40 + day);
      await storage.saveDailyLog(
        DailyLog(
          date: firstPeriodStart
              .add(Duration(days: day))
              .add(const Duration(hours: 9)),
          flowIntensity: 'Orta',
          observedSections: const {DailyLogObservedSection.period},
        ),
      );
    }

    final secondPeriodStart = firstPeriodStart.add(const Duration(days: 28));
    for (var day = 0; day < 5; day++) {
      await AppTime.setOffsetDays(-12 + day);
      await storage.saveDailyLog(
        DailyLog(
          date: secondPeriodStart
              .add(Duration(days: day))
              .add(const Duration(hours: 9)),
          flowIntensity: 'Orta',
          observedSections: const {DailyLogObservedSection.period},
        ),
      );
    }

    await AppTime.setOffsetDays(0);
    final refreshed = await storage.refreshCycleStatistics();

    expect(refreshed!.averageCycleLength, 28);
    expect(refreshed.averagePeriodLength, 4);
  });

  test('adet süresi ortalamasında uç değeri hesaba katmaz', () async {
    final firstPeriodStart = AppTime.now.dateOnly.subtract(
      const Duration(days: 120),
    );
    const durations = [5, 5, 5, 14];

    for (var period = 0; period < durations.length; period++) {
      final periodStart = firstPeriodStart.add(Duration(days: period * 28));
      for (var day = 0; day < durations[period]; day++) {
        await storage.saveDailyLog(
          DailyLog(
            date: periodStart.add(Duration(days: day, hours: 9)),
            flowIntensity: 'Orta',
            observedSections: const {DailyLogObservedSection.period},
          ),
        );
      }
    }

    final refreshed = await storage.refreshCycleStatistics();

    expect(refreshed!.averagePeriodLength, 5);
  });

  test('ardisik kanama kayitlari tek adet sayilir', () async {
    final firstStart = DateTime(2026, 5, 1);
    for (var day = 0; day < 3; day++) {
      await storage.saveDailyLog(
        DailyLog(
          date: firstStart.add(Duration(days: day, hours: 9)),
          flowIntensity: 'Orta',
        ),
      );
    }
    await storage.saveDailyLog(
      DailyLog(
        date: firstStart.add(const Duration(days: 28, hours: 9)),
        flowIntensity: 'Orta',
      ),
    );

    expect(storage.getPeriodStartDates(), [
      firstStart,
      firstStart.add(const Duration(days: 28)),
    ]);
  });
}
