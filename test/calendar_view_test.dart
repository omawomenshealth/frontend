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

    expect(find.text(AppStrings.month), findsNothing);
    expect(find.text(AppStrings.year), findsNothing);
    expect(
      find.byKey(const ValueKey('calendar-continuous-view')),
      findsOneWidget,
    );
    expect(find.text(AppStrings.editPeriodDates), findsOneWidget);
    expect(find.text(AppStrings.quickAddPeriod), findsNothing);
    expect(
      find.byKey(const ValueKey('calendar_period_edit_button')),
      findsOneWidget,
    );
    expect(find.byTooltip(AppStrings.close), findsOneWidget);
    expect(find.byTooltip(AppStrings.calendarLegend), findsOneWidget);
    final today = DateTime.now().dateOnly;
    final todayCell = find.byKey(
      ValueKey('calendar_day_${today.toStorageKey()}'),
    );
    expect(todayCell, findsOneWidget);
    expect(tester.getCenter(todayCell).dy, lessThan(210));
    expect(tester.takeException(), isNull);

    await tester.drag(
      find.byKey(const ValueKey('calendar-continuous-view')),
      const Offset(0, -2500),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('${today.year + 1}'), findsWidgets);

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

  testWidgets('Toplu adet düzenleme seçimleri yalnızca onayla uygulanır', (
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
    final skincareDay = today.subtract(const Duration(days: 1));
    final otherDay = today;
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

    await tester.tap(find.byKey(const ValueKey('calendar_period_edit_button')));
    await tester.pump();

    expect(
      find.byKey(const ValueKey('calendar_quick_period_hint')),
      findsOneWidget,
    );
    expect(find.text(AppStrings.confirm), findsOneWidget);
    expect(
      find.byKey(const ValueKey('calendar_quick_period_save')),
      findsNothing,
    );
    expect(skincareMarker, findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const ValueKey('calendar_period_edit_button')),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(
      find.byKey(ValueKey('calendar_day_${skincareDay.toStorageKey()}')),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(ValueKey('calendar_day_${otherDay.toStorageKey()}')),
    );
    await tester.pump();

    expect(find.text(AppStrings.deletePeriodConfirmationTitle), findsNothing);
    expect(
      find.byKey(ValueKey('period_pending_add_${skincareDay.toStorageKey()}')),
      findsOneWidget,
    );
    expect(
      find.byKey(ValueKey('period_pending_add_${otherDay.toStorageKey()}')),
      findsOneWidget,
    );
    expect(storage.loadLogsForDate(skincareDay).single.flowIntensity, isNull);
    expect(storage.loadLogsForDate(otherDay), isEmpty);

    await tester.tap(
      find.byKey(ValueKey('calendar_day_${skincareDay.toStorageKey()}')),
    );
    await tester.pump();
    expect(
      find.byKey(ValueKey('period_pending_add_${skincareDay.toStorageKey()}')),
      findsNothing,
    );
    await tester.tap(
      find.byKey(ValueKey('calendar_day_${skincareDay.toStorageKey()}')),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('calendar_period_edit_button')));
    await tester.pumpAndSettle();

    expect(
      storage.loadLogsForDate(skincareDay).single.flowIntensity,
      isNotNull,
    );
    expect(storage.loadLogsForDate(otherDay).single.flowIntensity, isNotNull);
    expect(skincareMarker, findsOneWidget);
    expect(
      find.byKey(const ValueKey('calendar_quick_period_hint')),
      findsNothing,
    );

    await tester.tap(find.byKey(const ValueKey('calendar_period_edit_button')));
    await tester.pump();

    await tester.tap(
      find.byKey(ValueKey('calendar_day_${skincareDay.toStorageKey()}')),
    );
    await tester.pump();
    expect(
      storage.loadLogsForDate(skincareDay).single.flowIntensity,
      isNotNull,
    );
    expect(
      find.byKey(
        ValueKey('period_pending_remove_${skincareDay.toStorageKey()}'),
      ),
      findsOneWidget,
    );
    await tester.tap(
      find.byKey(const ValueKey('calendar_cancel_period_changes')),
    );
    await tester.pump();
    expect(
      storage.loadLogsForDate(skincareDay).single.flowIntensity,
      isNotNull,
    );

    await tester.tap(find.byKey(const ValueKey('calendar_period_edit_button')));
    await tester.pump();
    await tester.tap(
      find.byKey(ValueKey('calendar_day_${skincareDay.toStorageKey()}')),
    );
    await tester.pump();
    expect(
      storage.loadLogsForDate(skincareDay).single.flowIntensity,
      isNotNull,
    );
    await tester.tap(find.byKey(const ValueKey('calendar_period_edit_button')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(
        ValueKey('period_edit_recorded_${skincareDay.toStorageKey()}'),
      ),
      findsNothing,
    );
    final savedOtherDay = storage.loadLogsForDate(otherDay).single;
    expect(savedOtherDay.flowIntensity, isNotNull);
    expect(
      AppStrings.localizeStoredValue(savedOtherDay.flowIntensity!),
      AppStrings.flowOptions[1],
    );
    expect(storage.loadLogsForDate(skincareDay).single.flowIntensity, isNull);
    expect(storage.loadLogsForDate(skincareDay).single.skincare, [
      'Niasinamid',
    ]);
    expect(tester.takeException(), isNull);
  });

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
