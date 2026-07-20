import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/main.dart';
import 'package:app_proje_a/views/insights/view/insights_view.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService();
    await storage.init();
    await tester.pumpWidget(MyApp(storage: storage));
    // Uygulama başarıyla oluşturuldu mu kontrol et
    expect(find.byType(MyApp), findsOneWidget);
  });

  testWidgets('İçgörüler sekmesi Ana Sayfa ile Yazılar arasındadır', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService();
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
    expect((navigation.items[0].icon as Icon).icon, Icons.dashboard_rounded);
    expect((navigation.items[1].icon as Icon).icon, Icons.insights_outlined);
    expect((navigation.items[2].icon as Icon).icon, Icons.article_rounded);

    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pump();

    expect(find.byType(InsightsView), findsOneWidget);
  });

  testWidgets('karşılaştırmalı bağlantı insight kartında gösterilir', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService();
    await storage.init();
    await storage.saveSettings(
      UserSettings(isOnboardingComplete: true, userName: 'Test'),
    );
    for (var day = 0; day < 20; day++) {
      await storage.saveDailyLog(
        DailyLog(
          date: DateTime(2026, 1, 1).add(Duration(days: day)),
          nutritionTags: day < 10 ? const ['Tuzlu'] : const [],
          painLocations: day < 8 || day == 15 ? const ['Şişkinlik'] : const [],
          observedSections: const {
            DailyLogObservedSection.nutrition,
            DailyLogObservedSection.wellbeing,
          },
        ),
      );
    }

    await tester.pumpWidget(MyApp(storage: storage));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.account_tree_outlined), findsWidgets);
  });
}
