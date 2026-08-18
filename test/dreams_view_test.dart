import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/views/profile/view/dreams_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Rüyalarım kabusları varsayılan olarak gizler ve açabilir', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    await storage.saveDailyLog(
      DailyLog(
        date: DateTime(2026, 8, 17, 8),
        dreamRemembered: true,
        dreamType: DreamType.good,
        dreamNote: 'Gökyüzünde uçuyordum.',
      ),
    );
    await storage.saveDailyLog(
      DailyLog(
        date: DateTime(2026, 8, 18, 8),
        dreamRemembered: true,
        dreamType: DreamType.nightmare,
        dreamNote: 'Karanlık bir koridorda kayboldum.',
      ),
    );

    await tester.pumpWidget(
      Provider<LocalStorageService>.value(
        value: storage,
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
          home: const DreamsView(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Gökyüzünde uçuyordum.'), findsOneWidget);
    expect(find.text('Karanlık bir koridorda kayboldum.'), findsNothing);
    expect(find.text('1 kabus gizli'), findsOneWidget);
    expect(find.text('Kabusları göster'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('dream_nightmare_visibility_toggle')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Karanlık bir koridorda kayboldum.'), findsOneWidget);
    expect(find.text('Kabusları gizle'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('dream_nightmare_visibility_toggle')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Karanlık bir koridorda kayboldum.'), findsNothing);
  });
}
