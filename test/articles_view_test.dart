import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/api_service.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/data/services/premium_purchase_service.dart';
import 'package:app_proje_a/views/articles/view/articles_view.dart';
import 'package:app_proje_a/views/dashboard/viewmodel/dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Keşfet ekranı editoryal düzeni ve aramayı korur', (
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
        userName: 'Özge',
        lastPeriodDate: DateTime.now().subtract(const Duration(days: 8)),
      ),
    );
    final api = _FakeArticlesApi(storage);
    final premium = PremiumPurchaseService(storage, api);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<ApiService>.value(value: api),
          ChangeNotifierProvider<PremiumPurchaseService>.value(value: premium),
          ChangeNotifierProvider(create: (_) => DashboardViewModel(storage)),
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
          home: const ArticlesView(),
        ),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('foliküler günlerin'), findsOneWidget);
    expect(find.byIcon(Icons.wb_sunny_outlined), findsOneWidget);
    expect(find.byIcon(Icons.bedtime_outlined), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.adjust_rounded), findsOneWidget);
    for (final grid in tester.widgetList<GridView>(find.byType(GridView))) {
      expect(grid.padding, EdgeInsets.zero);
      expect(grid.primary, isFalse);
    }
    expect(find.text('Döngünü Destekleyen Hareket'), findsOneWidget);
    expect(find.text('Daha İyi Bir Uyku Ritüeli'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final hero = tester.widget<Text>(find.text('foliküler günlerin'));
    expect(hero.style?.fontFamily, 'CormorantGaramond');

    await tester.enterText(find.byType(TextField), 'uyku');
    await tester.pump();

    expect(find.text('Daha İyi Bir Uyku Ritüeli'), findsOneWidget);
    expect(find.text('Döngünü Destekleyen Hareket'), findsNothing);
  });
}

class _FakeArticlesApi extends ApiService {
  _FakeArticlesApi(super.storage);

  static const articles = <Map<String, dynamic>>[
    {
      'id': 'movement',
      'title': 'Döngünü Destekleyen Hareket',
      'summary': 'Enerjine uyum sağlayan yumuşak bir hareket pratiği.',
      'topic': 'Movement',
      'imageKey': 'movement',
      'displaySection': 'movement',
      'displayStyle': 'grid',
      'readTimeMinutes': 6,
      'cardColor': '#89986D',
      'isPremium': false,
      'canAccess': true,
    },
    {
      'id': 'sleep',
      'title': 'Daha İyi Bir Uyku Ritüeli',
      'summary': 'Akşam bedenini dinlendirmek için küçük adımlar.',
      'topic': 'Rituals',
      'imageKey': 'sleep',
      'displaySection': 'rituals',
      'displayStyle': 'row',
      'readTimeMinutes': 8,
      'cardColor': '#8A72B0',
      'isPremium': false,
      'canAccess': true,
    },
    {
      'id': 'nutrition',
      'title': 'Fazına Göre Beslenme',
      'summary': 'Günlük enerjini destekleyen pratik öneriler.',
      'topic': 'Nourish',
      'imageKey': 'nutrition',
      'displaySection': 'nourish',
      'displayStyle': 'grid',
      'readTimeMinutes': 5,
      'cardColor': '#C0606E',
      'isPremium': true,
      'canAccess': false,
    },
  ];

  @override
  Future<List<Map<String, dynamic>>> fetchArticles() async => articles;

  @override
  Future<Map<String, dynamic>> fetchArticle(String articleId) async {
    return articles.firstWhere((article) => article['id'] == articleId);
  }
}
