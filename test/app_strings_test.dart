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
    expect(AppStrings.localizeStoredValue('Dengeli'), 'Medium');
    expect(
      AppStrings.insightCycleLengthBody(29),
      'There were 29 days between your two latest recorded period starts.',
    );
    expect(
      AppStrings.insightSymptomMoodBody(
        primary: 'Headache',
        secondary: 'Tired',
        count: 3,
      ),
      'Headache and Tired were logged on the same day 3 times. '
      'They appeared together in your logs, but this does not show that one '
      'caused the other.',
    );
    expect(AppStrings.insightEvidenceDays(4), 'Logged days: 4');
    expect(
      AppStrings.localizeInsightFeature('cyclePhase:follicular'),
      'Follicular phase',
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
      contains('only shows a connection worth revisiting.'),
    );
    expect(
      AppStrings.insightMoodPlaceBody(
        mood: 'Great',
        place: 'Seaside park',
        withEvent: 8,
        withTotal: 10,
        withoutTotal: 10,
        withPercent: 80,
        withoutPercent: 10,
      ),
      contains('Notice how that environment feels'),
    );
    expect(
      AppStrings.phaseOvulationFertility,
      startsWith('Estimated chance of pregnancy'),
    );
    expect(
      AppStrings.exploreOvulationDescription,
      startsWith('Estimated chance of pregnancy'),
    );
    expect(
      AppStrings.periodPredictionLowConfidenceSummary('9/17 - 9/29'),
      'Period prediction: 9/17 - 9/29 · '
      'Add more data for more accurate results',
    );
    expect(AppStrings.symptomEnergyLevelOptions, [
      'Energetic',
      'Fatigue',
      'Exhausted/burned out',
    ]);
    expect(AppStrings.symptomMoodStateOptions, [
      'Motivated',
      'Calm and balanced',
      'Restless',
      'Irritable',
      'Emotional ups and downs',
    ]);
    expect(AppStrings.symptomMentalClarityOptions, [
      'Focused',
      'Brain fog',
      'Forgetful',
    ]);
    expect(AppStrings.symptomSleepQualityOptions, [
      'Slept well',
      'Slept fairly well',
      'Slept poorly',
      'Trouble falling asleep',
      'Woke often',
    ]);
    expect(AppStrings.symptomWakeFeelingOptions, [
      'Woke up energized',
      'Woke up rested',
      'Woke up sleepy/tired',
      'Woke up with a headache',
      'Woke up early',
    ]);
    expect(AppStrings.localizeStoredValue('Deep sleep'), 'Deep sleep');
    expect(AppStrings.localizeStoredValue('Woke refreshed'), 'Woke up rested');
  });

  test('İçgörü şablonları Türkçe parametrelerle biçimlenir', () async {
    await AppStrings.delegate.load(const Locale('tr', 'TR'));

    expect(AppStrings.localizeStoredValue('Balanced'), 'Orta');
    expect(
      AppStrings.insightRecordingSummaryBody(loggedDays: 8, spanDays: 14),
      'Son 14 günlük aralıkta 8 farklı güne kayıt ekledin.',
    );
    expect(
      AppStrings.insightFrequentMoodBody(label: 'Yorgun', count: 5, total: 8),
      'Ruh hâlini kaydettiğin 8 günün 5 tanesinde Yorgun seçtin.',
    );
    expect(AppStrings.insightEvidenceCycles(3), 'Hesaplanan döngü: 3');
    expect(
      AppStrings.dosageOptions.every((dose) => dose.endsWith('Adet')),
      isTrue,
    );
    expect(AppStrings.womenDiseasesList, contains('Adenomyozis'));
    expect(AppStrings.womenDiseasesList, isNot(contains('Diğer')));
    expect(AppStrings.chronicDiseasesList, isNot(contains('Diğer')));
    expect(AppStrings.symptomSkinHairOptions, contains('Yağlı cilt'));
    expect(AppStrings.symptomOverallOptions, ['Her şey yolunda', 'Stres']);
    expect(AppStrings.localizeStoredValue('Stress'), 'Stres');
    expect(
      AppStrings.periodPredictionLowConfidenceSummary('17.9 - 29.9'),
      'Tahmini adet başlangıcı: 17.9 - 29.9 · '
      'Verilerinle daha doğru sonuçlar elde edelim',
    );
    expect(AppStrings.symptomEnergyLevelOptions, [
      'Enerjik',
      'Yorgunluk',
      'Bitkin/tükenmiş',
    ]);
    expect(AppStrings.symptomMoodStateOptions, [
      'Motivasyonlu',
      'Sakin ve dengeli',
      'Huzursuzluk',
      'Sinirlilik',
      'Duygusal iniş çıkış',
    ]);
    expect(AppStrings.symptomMentalClarityOptions, [
      'Odaklanmış',
      'Zihin bulanıklığı',
      'Unutkanlık',
    ]);
    expect(AppStrings.symptomSleepQualityOptions, [
      'İyi uyudum',
      'Orta kalitede uyudum',
      'Kötü uyudum',
      'Uykuya dalmakta zorlandım',
      'Sık uyandım',
    ]);
    expect(AppStrings.symptomWakeFeelingOptions, [
      'Enerjik uyandım',
      'Dinlenmiş uyandım',
      'Uykulu/yorgun uyandım',
      'Baş ağrısıyla uyandım',
      'Erken uyandım',
    ]);
    expect(
      AppStrings.symptomSleepOptions
          .skip(AppStrings.symptomSleepOptions.length - 2)
          .toList(),
      ['Canlı rüyalar', 'Kâbus'],
    );
    expect(AppStrings.localizeStoredValue('Refreshed'), 'Dinç');
    expect(AppStrings.localizeStoredValue('Back pain'), 'Bel ağrısı');
    expect(AppStrings.symptomDigestionOptions, contains('Midem iyi'));
    expect(AppStrings.skincareCatalog.keys, [
      'Akne, Yağlanma ve Gözenek',
      'Eksfoliasyon ve Doku',
      'Hassasiyet ve Yatıştırma',
      'Leke ve Ton Eşitsizliği',
      'Nemlendirme ve Bariyer',
      'Yaşlanma Karşıtı ve Antioksidan',
    ]);
    final skincareIngredients = AppStrings.skincareCatalog.values
        .expand((ingredients) => ingredients)
        .toList();
    expect(skincareIngredients, hasLength(34));
    expect(skincareIngredients.toSet(), hasLength(34));
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
      'Foliküler Faz günlerinde ruh hâlini kaydettiğin 20 günün 12 tanesinde '
      'Mutlu seçtin (%60). Diğer fazlardaki 40 karşılaştırılabilir günde bu '
      'oran %20. Bu yalnızca bir zamanlama ilişkisi; fazın bu hisse neden '
      'olduğunu göstermez.',
    );
  });

  test(
    'Dinamik Türkçe insight cümleleri bağımsız de veya da kullanmaz',
    () async {
      await AppStrings.delegate.load(const Locale('tr', 'TR'));
      final texts = [
        AppStrings.insightMoodSymptomBody(
          mood: 'Hassas',
          symptom: 'Baş ağrısı',
          withEvent: 8,
          withTotal: 10,
          withoutTotal: 10,
          withPercent: 80,
          withoutPercent: 10,
        ),
        AppStrings.insightMoodFoodBody(
          mood: 'İyi',
          food: 'Ev yapımı granola',
          withEvent: 8,
          withTotal: 10,
          withoutTotal: 10,
          withPercent: 80,
          withoutPercent: 10,
        ),
        AppStrings.insightMoodCravingBody(
          mood: 'Düşük',
          craving: 'Çikolata',
          withEvent: 8,
          withTotal: 10,
          withoutTotal: 10,
          withPercent: 80,
          withoutPercent: 10,
        ),
        AppStrings.insightFoodBowelBody(
          food: 'Acılı ev yemeği',
          bowel: 'Şişkinlik',
          withEvent: 8,
          withTotal: 10,
          withoutTotal: 10,
          withPercent: 80,
          withoutPercent: 10,
          lagDays: 0,
        ),
        AppStrings.insightMoodPlaceBody(
          mood: 'Harika',
          place: 'Sahil parkı',
          withEvent: 8,
          withTotal: 10,
          withoutTotal: 10,
          withPercent: 80,
          withoutPercent: 10,
        ),
        AppStrings.insightMoodCompanionBody(
          mood: 'İyi',
          companion: 'Yakın arkadaşım',
          withEvent: 8,
          withTotal: 10,
          withoutTotal: 10,
          withPercent: 80,
          withoutPercent: 10,
        ),
        AppStrings.insightStressCompanionBody(
          companion: 'Yakın arkadaşım',
          withEvent: 8,
          withTotal: 10,
          withoutTotal: 10,
          withPercent: 80,
          withoutPercent: 10,
        ),
        AppStrings.insightStressCravingBody(
          craving: 'Çikolata',
          withEvent: 8,
          withTotal: 10,
          withoutTotal: 10,
          withPercent: 80,
          withoutPercent: 10,
        ),
        AppStrings.insightStressFoodBody(
          food: 'Ev yapımı granola',
          withEvent: 8,
          withTotal: 10,
          withoutTotal: 10,
          withPercent: 80,
          withoutPercent: 10,
        ),
        AppStrings.insightAssociationBody(
          primary: 'Gluten',
          secondary: 'Şişkinlik',
          withEvent: 8,
          withTotal: 10,
          withoutTotal: 10,
          withPercent: 80,
          withoutPercent: 10,
          lagDays: 0,
        ),
      ];
      final standaloneDeDa = RegExp(
        r'(^|\s)(de|da)(?=\s|[.,;:!?])',
        caseSensitive: false,
      );

      expect(texts.where(standaloneDeDa.hasMatch), isEmpty);
    },
  );

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
