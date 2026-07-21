import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() async {
    await AppStrings.delegate.load(AppStrings.fallbackLocale);
  });

  test('Türkçe ve İngilizce kataloglar bütün anahtarları içerir', () {
    expect(AppStrings.catalogsAreComplete, isTrue);
  });

  test('İngilizce katalog ve dinamik metinler seçilebilir', () async {
    await AppStrings.delegate.load(const Locale('en', 'US'));

    expect(AppStrings.home, 'Home');
    expect(AppStrings.dayCount(1), '1 day');
    expect(AppStrings.dayCount(3), '3 days');
    expect(AppStrings.localizeStoredValue('Yoğun'), 'Heavy');
    expect(
      AppStrings.insightCycleLengthBody(29),
      'There are 29 days between your two latest recorded period starts.',
    );
    expect(
      AppStrings.insightSymptomMoodBody(
        primary: 'Headache',
        secondary: 'Tired',
        count: 3,
      ),
      'Headache and Tired were logged on the same day 3 times. '
      'This is an association only.',
    );
    expect(AppStrings.insightEvidenceDays(4), 'Logged days: 4');
    expect(
      AppStrings.localizeInsightFeature('cyclePhase:follicular'),
      'Follicular Phase',
    );
    expect(
      AppStrings.insightAssociationBody(
        primary: 'Salty',
        secondary: 'Bloating',
        withEvent: 8,
        withTotal: 10,
        withoutTotal: 10,
        withPercent: 80,
        withoutPercent: 10,
        lagDays: 0,
      ),
      contains('This is an association, not cause and effect.'),
    );
  });

  test('İçgörü şablonları Türkçe parametrelerle biçimlenir', () async {
    await AppStrings.delegate.load(const Locale('tr', 'TR'));

    expect(
      AppStrings.insightRecordingSummaryBody(loggedDays: 8, spanDays: 14),
      '14 günlük zaman aralığında 8 farklı gün için sağlık kaydı oluşturdun.',
    );
    expect(
      AppStrings.insightFrequentMoodBody(label: 'Yorgun', count: 5, total: 8),
      'Yorgun, ruh hâli girdiğin 8 günün 5 tanesinde yer aldı.',
    );
    expect(AppStrings.insightEvidenceCycles(3), 'Hesaplanan döngü: 3');
    expect(
      AppStrings.insightMoodCyclePhaseBody(
        mood: 'Mutlu',
        phase: 'Foliküler Faz',
        withEvent: 12,
        withTotal: 20,
        withoutTotal: 40,
        withPercent: 60,
        withoutPercent: 20,
      ),
      'Mutlu, “Foliküler Faz” günlerinde ruh hâli girdiğin 20 günün 12 '
      'tanesinde kaydedildi (%60). Diğer fazlarda ruh hâli girdiğin 40 günde '
      'bu oran %20. Bu bir ilişkidir; döngü fazının ruh hâline neden olduğunu '
      'göstermez.',
    );
    expect(
      AppStrings.insightEnergyCyclePhaseBody(
        energy: 'düşük enerji',
        phase: 'Luteal Faz',
        withEvent: 15,
        withTotal: 20,
        withoutTotal: 40,
        withPercent: 75,
        withoutPercent: 25,
      ),
      'düşük enerji, “Luteal Faz” günlerinde enerji düzeyi girdiğin 20 günün '
      '15 tanesinde görüldü (%75). Diğer fazlarda enerji düzeyi girdiğin 40 '
      'günde bu oran %25. Bu bir ilişkidir; döngü fazının enerji düzeyine neden '
      'olduğunu göstermez.',
    );
  });

  test('Desteklenmeyen dil İngilizceye düşer', () {
    expect(
      AppStrings.resolveLocale(const Locale('de', 'DE')),
      const Locale('en', 'US'),
    );
  });

  testWidgets('widgetlar locale değiştiğinde yeniden çevrilir', (tester) async {
    Widget app(Locale locale) {
      return MaterialApp(
        locale: locale,
        supportedLocales: AppStrings.supportedLocales,
        localizationsDelegates: const [
          AppStrings.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) {
            AppStrings.of(context);
            return Text(AppStrings.home);
          },
        ),
      );
    }

    await tester.pumpWidget(app(const Locale('en', 'US')));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);

    await tester.pumpWidget(app(const Locale('tr', 'TR')));
    await tester.pumpAndSettle();
    expect(find.text('Ana Sayfa'), findsOneWidget);
  });
}
