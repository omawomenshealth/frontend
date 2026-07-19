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
