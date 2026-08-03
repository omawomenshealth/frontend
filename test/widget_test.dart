import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/data/models/medication_reminder_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/main.dart';
import 'package:app_proje_a/views/insights/view/insights_view.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await tester.pumpWidget(MyApp(storage: storage));
    // Uygulama başarıyla oluşturuldu mu kontrol et
    expect(find.byType(MyApp), findsOneWidget);
  });

  testWidgets('Keşfet ve İçgörüler kaynak tasarımdaki sıradadır', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.saveSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Test'),
    );

    await tester.pumpWidget(MyApp(storage: storage));
    await tester.pump();

    final navigation = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(navigation.items, hasLength(4));
    expect((navigation.items[0].icon as Icon).icon, Icons.home_outlined);
    expect((navigation.items[1].icon as Icon).icon, Icons.explore_outlined);
    expect(
      (navigation.items[2].icon as Icon).icon,
      Icons.auto_awesome_outlined,
    );

    navigation.onTap!(2);
    await tester.pump();

    expect(find.byType(InsightsView), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsNothing);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
  });

  testWidgets('İçgörü süre barı dolunca sonraki kart otomatik oynar', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.saveSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Test'),
    );
    final start = DateTime.now().subtract(const Duration(days: 19));
    for (var day = 0; day < 20; day++) {
      await storage.saveDailyLog(
        DailyLog(
          date: start.add(Duration(days: day)),
          mood: day < 10 ? 'İyi' : 'Nötr',
          symptoms: day < 8 || day == 15 ? const ['Baş ağrısı'] : const [],
          moodPlaces: day < 8 || day == 15 ? const ['Ev'] : const [],
          observedSections: const {
            DailyLogObservedSection.wellbeing,
            DailyLogObservedSection.symptom,
          },
        ),
      );
    }

    await tester.pumpWidget(MyApp(storage: storage));
    await tester.pump();
    tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar)).onTap!(
      2,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final storyPageView = find.descendant(
      of: find.byType(InsightsView),
      matching: find.byType(PageView),
    );
    final pageView = tester.widget<PageView>(storyPageView);
    expect(pageView.controller!.page, 0);

    await tester.pump(const Duration(milliseconds: 4400));
    final halfFilled = tester.widget<FractionallySizedBox>(
      find.byKey(const ValueKey('insight_progress_fill_0')),
    );
    expect(halfFilled.widthFactor, inInclusiveRange(0.45, 0.55));

    await tester.pump(const Duration(milliseconds: 4700));
    await tester.pump(const Duration(milliseconds: 400));

    expect(pageView.controller!.page, closeTo(1, 0.01));
  });

  testWidgets(
    'planlanan dozlar ana ekranda, eski yolculuk şeridi olmadan görünür',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
      await storage.init();
      await storage.saveSettings(
        UserSettings(isOnboardingComplete: true, userName: 'Test'),
      );
      final now = DateTime.now();
      final scheduledAt = DateTime(now.year, now.month, now.day, 23, 55);
      final reminderPlan = MedicationReminderPlan(
        id: 'plan-1',
        itemType: MedicationPlanItemType.medication,
        itemName: 'Test ilacı',
        dosage: '3 Adet',
        times: const [ReminderClockTime(hour: 23, minute: 55)],
        frequency: MedicationPlanFrequency.everyDay,
        weekdays: const {1, 2, 3, 4, 5, 6, 7},
        startDate: DateTime(now.year, now.month, now.day),
        endDate: null,
        enabled: true,
        createdAt: now,
        updatedAt: now,
      );
      await storage.saveMedicationReminderPlans([reminderPlan]);
      await storage.saveMedicationDoseRecords([
        MedicationDoseRecord(
          id: MedicationScheduleCalculator.doseId(reminderPlan.id, scheduledAt),
          planId: reminderPlan.id,
          itemType: MedicationPlanItemType.medication,
          itemName: 'Test ilacı',
          dosage: '3 Adet',
          scheduledAt: scheduledAt,
          notificationScheduled: true,
          notificationScheduledAt: now,
          status: null,
          respondedAt: null,
        ),
      ]);

      await tester.pumpWidget(MyApp(storage: storage));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('dashboard_planned_doses')),
        findsOneWidget,
      );
      for (final label in AppStrings.journeyLabels) {
        expect(find.text(label), findsNothing);
      }
    },
  );

  testWidgets('geri tuşu önce ana sayfaya döner', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.saveSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Test'),
    );

    await tester.pumpWidget(MyApp(storage: storage));
    await tester.pumpAndSettle();

    var navigation = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    navigation.onTap!(3);
    await tester.pumpAndSettle();
    navigation = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(navigation.currentIndex, 3);

    Navigator.of(tester.element(find.byType(HomeShell))).push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Alt sayfa')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Alt sayfa'), findsOneWidget);

    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();

    navigation = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(navigation.currentIndex, 0);
    expect(await tester.binding.handlePopRoute(), isFalse);
  });

  testWidgets('karşılaştırmalı bağlantı insight kartında gösterilir', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.saveSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Test'),
    );
    for (var day = 0; day < 20; day++) {
      await storage.saveDailyLog(
        DailyLog(
          date: DateTime(2026, 1, 1).add(Duration(days: day)),
          mealTypes: const ['Kahvaltı'],
          mealFoodGroups: day < 10
              ? const {
                  'Kahvaltı': ['Gluten'],
                }
              : const {
                  'Kahvaltı': ['Yumurta'],
                },
          symptoms: day < 8 || day == 15 ? const ['Şişkinlik'] : const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.wellbeing,
          },
        ),
      );
    }

    await tester.pumpWidget(MyApp(storage: storage));
    await tester.pump();
    final navigation = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    navigation.onTap!(2);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward_rounded), findsWidgets);
  });

  testWidgets('ana sayfadaki insight kartları kendi detayını ve tümünü açar', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.saveSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Test'),
    );
    for (var day = 0; day < 20; day++) {
      await storage.saveDailyLog(
        DailyLog(
          date: DateTime(2026, 1, 1).add(Duration(days: day)),
          mealTypes: const ['Kahvaltı'],
          mealFoodGroups: day < 10
              ? const {
                  'Kahvaltı': ['Gluten'],
                }
              : const {
                  'Kahvaltı': ['Yumurta'],
                },
          symptoms: day < 8 || day == 15 ? const ['Şişkinlik'] : const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.wellbeing,
          },
        ),
      );
    }

    await tester.pumpWidget(MyApp(storage: storage));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('dashboard_personal_insights')),
      findsOneWidget,
    );
    expect(find.byType(PersonalInsightCard), findsWidgets);

    final previewCards = find.descendant(
      of: find.byKey(const ValueKey('dashboard_personal_insights')),
      matching: find.byType(PersonalInsightCard),
    );
    final cards = tester.widgetList<PersonalInsightCard>(previewCards).toList();
    expect(cards.length, greaterThan(1));
    expect(cards.every((card) => card.onTap != null), isTrue);

    final firstInsight = cards.first.insight;
    final tappedInsight = cards[1].insight;
    await tester.ensureVisible(previewCards.at(1));
    await tester.tap(previewCards.at(1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));

    final openedDetail = tester.widget<InsightsView>(find.byType(InsightsView));
    expect(openedDetail.initialInsightId, tappedInsight.id);
    expect(
      find
          .byKey(PageStorageKey<String>('insight_story_${tappedInsight.id}'))
          .hitTestable(),
      findsOneWidget,
    );

    final storyPageView = find.descendant(
      of: find.byType(InsightsView),
      matching: find.byType(PageView),
    );
    final pageView = tester.widget<PageView>(storyPageView);
    final storyCount = pageView.childrenDelegate.estimatedChildCount!;
    for (var index = 1; index < storyCount; index++) {
      final nextButton = find.widgetWithText(FilledButton, AppStrings.next);
      await tester.tap(nextButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    }
    expect(
      find
          .byKey(PageStorageKey<String>('insight_story_${firstInsight.id}'))
          .hitTestable(),
      findsOneWidget,
    );

    Navigator.of(tester.element(find.byType(InsightsView))).pop();
    await tester.pumpAndSettle();

    final viewAllButton = find.byKey(
      const ValueKey('dashboard_view_all_insights'),
    );
    await tester.ensureVisible(viewAllButton);
    await tester.pumpAndSettle();
    await tester.tap(viewAllButton);
    await tester.pumpAndSettle();

    expect(find.byType(InsightsView), findsOneWidget);
  });
}
