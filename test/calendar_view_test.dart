import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/views/calendar/view/calendar_view.dart';
import 'package:app_proje_a/views/calendar/viewmodel/calendar_view_model.dart';
import 'package:app_proje_a/views/dashboard/viewmodel/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Yeni takvim tasarımı mevcut kayıt akışını korur', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.saveSettings(
      UserSettings(
        isOnboardingComplete: true,
        userName: 'Test',
        lastPeriodDate: DateTime.now().subtract(const Duration(days: 8)),
      ),
    );

    final calendar = CalendarViewModel(storage);
    final dashboard = DashboardViewModel(storage);
    await calendar.loadData();
    await dashboard.loadData();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: calendar),
          ChangeNotifierProvider.value(value: dashboard),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: const Locale('tr'),
          localizationsDelegates: const [
            AppStrings.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppStrings.supportedLocales,
          home: const CalendarView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(AppStrings.month), findsOneWidget);
    expect(find.text(AppStrings.year), findsOneWidget);
    expect(find.text(AppStrings.editPeriodDates), findsOneWidget);
    expect(find.byTooltip(AppStrings.close), findsOneWidget);
    expect(find.byTooltip(AppStrings.calendarLegend), findsOneWidget);
    expect(tester.takeException(), isNull);

    calendar.selectDay(DateTime.now().add(const Duration(days: 1)));
    await tester.pump();
    final futureEditButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, AppStrings.editPeriodDates),
    );
    expect(futureEditButton.onPressed, isNull);

    calendar.selectDay(DateTime.now());
    await tester.pump();
    await tester.tap(find.text(AppStrings.year));
    await tester.pumpAndSettle();
    expect(find.text('${DateTime.now().year}'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byTooltip(AppStrings.calendarLegend));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.recordedPeriod), findsOneWidget);
    expect(find.text(AppStrings.predictedPeriod), findsOneWidget);
    expect(find.text(AppStrings.fertileDays), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('Takvim gerçek ve tahmini adet günlerini ayırır', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();

    final recordedDay = DateTime.now().subtract(const Duration(days: 3));
    await storage.saveSettings(
      UserSettings(
        isOnboardingComplete: true,
        lastPeriodDate: recordedDay,
        averageCycleLength: 28,
        averagePeriodLength: 5,
      ),
    );
    await storage.saveDailyLog(
      DailyLog(date: recordedDay, flowIntensity: 'Orta'),
    );

    final calendar = CalendarViewModel(storage);
    await calendar.loadData();
    final predictedDay = recordedDay.add(const Duration(days: 28));

    expect(calendar.isLoggedPeriodDay(recordedDay), isTrue);
    expect(calendar.isPredictedPeriodDay(recordedDay), isFalse);
    expect(calendar.isPeriodDay(predictedDay), isTrue);
    expect(calendar.isPredictedPeriodDay(predictedDay), isTrue);
  });
}
