import 'package:app_proje_a/application/cycle_prediction/cycle_prediction_coordinator.dart';
import 'package:app_proje_a/core/utils/app_time.dart';
import 'package:app_proje_a/core/utils/date_extensions.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/domain/cycle/models/cycle_prediction.dart';
import 'package:app_proje_a/views/calendar/viewmodel/calendar_view_model.dart';
import 'package:app_proje_a/views/dashboard/viewmodel/dashboard_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalStorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppTime.init(initialOffsetDays: 0);
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

  test(
    'forecast şifreli yerel snapshot olarak saklanır ve yeniden kullanılır',
    () async {
      await _seedRegularHistory(storage);
      final first = CyclePredictionCoordinator(storage);
      await first.refresh(force: true);

      final forecast = first.forecast;
      expect(forecast, isNotNull);
      expect(forecast!.medianStart.isBefore(AppTime.now.dateOnly), isFalse);
      expect(storage.loadCycleForecastSnapshot(), isNotNull);

      final preferences = await SharedPreferences.getInstance();
      expect(
        preferences.getKeys(),
        isNot(contains('cycle_forecast_snapshot_v1')),
      );

      final second = CyclePredictionCoordinator(storage);
      await second.refresh();
      expect(second.forecast!.forecastId, forecast.forecastId);

      first.dispose();
      second.dispose();
    },
  );

  test('Dashboard ve Calendar aynı coordinator snapshotını tüketir', () async {
    await _seedRegularHistory(storage);
    final coordinator = CyclePredictionCoordinator(storage);
    final dashboard = DashboardViewModel(storage, null, coordinator);
    final calendar = CalendarViewModel(storage, coordinator);

    await dashboard.loadData();
    await calendar.loadData();

    expect(dashboard.cycleForecast, isNotNull);
    expect(
      dashboard.cycleForecast!.forecastId,
      calendar.cycleForecast!.forecastId,
    );
    expect(
      calendar.isPeriodPredictionWindowDay(
        dashboard.cycleForecast!.p80Window.start,
      ),
      isTrue,
    );

    dashboard.dispose();
    calendar.dispose();
    coordinator.dispose();
  });

  test('postmenopozda tahmin bastırılır', () async {
    await _seedRegularHistory(storage);
    final current = storage.loadSettings()!;
    await storage.saveSettings(
      current.copyWith(menopauseStatus: MenopauseStatus.post),
    );
    final coordinator = CyclePredictionCoordinator(storage);

    await coordinator.refresh(force: true);

    expect(coordinator.forecast, isNull);
    expect(
      coordinator.suppressionReason,
      CyclePredictionSuppressionReason.postmenopause,
    );
    expect(storage.loadCycleForecastSnapshot(), isNull);
    coordinator.dispose();
  });
}

Future<void> _seedRegularHistory(LocalStorageService storage) async {
  final lastStart = AppTime.now.dateOnly.subtract(const Duration(days: 27));
  for (var cycle = 4; cycle >= 0; cycle--) {
    final start = lastStart.subtract(Duration(days: cycle * 28));
    for (var day = 0; day < 3; day++) {
      await storage.saveDailyLog(
        DailyLog(
          date: start.add(Duration(days: day, hours: 9)),
          flowIntensity: day == 0 ? 'Orta' : 'Hafif',
          observedSections: const {DailyLogObservedSection.period},
        ),
      );
    }
  }
}
