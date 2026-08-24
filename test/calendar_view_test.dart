import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/utils/date_extensions.dart';
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
    expect(find.text(AppStrings.quickAddPeriod), findsOneWidget);
    expect(find.byTooltip(AppStrings.close), findsOneWidget);
    expect(find.byTooltip(AppStrings.calendarLegend), findsOneWidget);
    expect(tester.takeException(), isNull);

    calendar.selectDay(DateTime.now().add(const Duration(days: 1)));
    await tester.pump();
    final futureEditButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, AppStrings.editPeriodDates),
    );
    expect(futureEditButton.onPressed, isNull);
    final futureQuickButton = tester.widget<OutlinedButton>(
      find.byKey(const ValueKey('calendar_quick_add_period')),
    );
    expect(futureQuickButton.onPressed, isNull);

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

  test(
    'Hızlı adet kaydı birden çok günü hafif ekler ve diğer veriyi korur',
    () async {
      SharedPreferences.setMockInitialValues({});
      final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
      await storage.init();
      final today = DateTime.now().dateOnly;
      final start = today.subtract(const Duration(days: 4));
      await storage.saveSettings(
        UserSettings(isOnboardingComplete: true, lastPeriodDate: start),
      );
      await storage.saveDailyLog(
        DailyLog(
          date: start,
          hasExplicitTime: false,
          skincare: const ['Niasinamid'],
          observedSections: const {DailyLogObservedSection.skincare},
        ),
      );
      final calendar = CalendarViewModel(storage);
      await calendar.loadData();
      final selectedDays = List.generate(
        3,
        (index) => start.add(Duration(days: index)),
      );

      expect(await calendar.addLightPeriodDays(selectedDays), isTrue);

      for (final day in selectedDays) {
        final periodLog = storage
            .loadLogsForDate(day)
            .firstWhere((log) => log.flowIntensity != null);
        expect(
          AppStrings.localizeStoredValue(periodLog.flowIntensity!),
          AppStrings.flowOptions[1],
        );
        expect(periodLog.hasExplicitTime, isFalse);
        expect(
          periodLog.observedSections,
          contains(DailyLogObservedSection.period),
        );
      }
      expect(storage.loadLogsForDate(start).single.skincare, ['Niasinamid']);
    },
  );

  testWidgets(
    'Hızlı adet seçimi aynı takvimde çoklu çalışır ve diğer kayıt rengini korur',
    (tester) async {
      tester.view.physicalSize = const Size(430, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({});
      final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
      await storage.init();
      final today = DateTime.now().dateOnly;
      final skincareDay = today.subtract(const Duration(days: 2));
      final otherDay = today.subtract(const Duration(days: 1));
      await storage.saveSettings(
        UserSettings(
          isOnboardingComplete: true,
          lastPeriodDate: today.subtract(const Duration(days: 10)),
        ),
      );
      await storage.saveDailyLog(
        DailyLog(
          date: skincareDay,
          hasExplicitTime: false,
          skincare: const ['Niasinamid'],
          observedSections: const {DailyLogObservedSection.skincare},
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

      final skincareMarker = find.byKey(
        ValueKey('calendar_log_marker_${skincareDay.toStorageKey()}'),
      );
      expect(skincareMarker, findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('calendar_quick_add_period')));
      await tester.pump();

      expect(
        find.byKey(const ValueKey('calendar_quick_period_hint')),
        findsOneWidget,
      );
      expect(find.text(AppStrings.month), findsOneWidget);
      expect(skincareMarker, findsOneWidget);

      await tester.tap(
        find.byKey(ValueKey('calendar_day_${skincareDay.toStorageKey()}')),
      );
      await tester.tap(
        find.byKey(ValueKey('calendar_day_${otherDay.toStorageKey()}')),
      );
      await tester.pump();

      expect(
        find.byKey(
          ValueKey('quick_period_selected_${skincareDay.toStorageKey()}'),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          ValueKey('quick_period_selected_${otherDay.toStorageKey()}'),
        ),
        findsOneWidget,
      );
      expect(skincareMarker, findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('calendar_quick_period_save')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('calendar_quick_period_hint')),
        findsNothing,
      );
      for (final day in [skincareDay, otherDay]) {
        final savedLog = storage.loadLogsForDate(day).single;
        expect(savedLog.flowIntensity, isNotNull);
        expect(
          AppStrings.localizeStoredValue(savedLog.flowIntensity!),
          AppStrings.flowOptions[1],
        );
      }
      expect(storage.loadLogsForDate(skincareDay).single.skincare, [
        'Niasinamid',
      ]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Takvim günlük log ayrıntısında skincare görünür', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    final today = DateTime.now().dateOnly;
    await storage.saveSettings(
      UserSettings(isOnboardingComplete: true, lastPeriodDate: today),
    );
    await storage.saveDailyLog(
      DailyLog(
        date: today.add(const Duration(hours: 9)),
        skincare: const ['Niasinamid'],
        observedSections: const {DailyLogObservedSection.skincare},
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

    await tester.tap(
      find.byKey(ValueKey('calendar_day_${today.toStorageKey()}')),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.skincare), findsOneWidget);
    expect(find.text('Niasinamid'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
