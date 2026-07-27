import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/views/dashboard/widgets/daily_log_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Yeni adet kayıt tasarımı seçimi mevcut modele kaydeder', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = await _storage();
    DailyLog? savedLog;

    await tester.pumpWidget(
      _TestApp(
        storage: storage,
        onSave: (log) async {
          savedLog = log;
          return true;
        },
      ),
    );

    await tester.tap(find.text('Aç'));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.logPeriodQuestion), findsOneWidget);
    expect(find.text(AppStrings.savePeriod), findsOneWidget);
    expect(find.byIcon(Icons.water_drop_rounded), findsWidgets);
    expect(tester.takeException(), isNull);

    final mediumFlow = find.text(AppStrings.flowOptions[2]);
    await tester.ensureVisible(mediumFlow);
    await tester.pumpAndSettle();
    await tester.tap(mediumFlow);
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.savePeriod));
    await tester.pumpAndSettle();

    expect(savedLog, isNotNull);
    expect(
      AppStrings.localizeStoredValue(savedLog!.flowIntensity!),
      AppStrings.flowOptions[2],
    );
    expect(
      savedLog!.observedSections,
      contains(DailyLogObservedSection.period),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tüm günlük kayıt sekmeleri yeni tasarım başlıklarını gösterir', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = await _storage();
    await tester.pumpWidget(
      _TestApp(storage: storage, onSave: (_) async => true),
    );
    await tester.tap(find.text('Aç'));
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.nutrition));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.logNutritionQuestion), findsOneWidget);
    expect(find.text(AppStrings.logHydration.toUpperCase()), findsOneWidget);
    expect(find.text(AppStrings.saveNutrition), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.text(AppStrings.medications).first);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.logMedicationQuestion), findsOneWidget);
    expect(find.text(AppStrings.saveMedication), findsOneWidget);
    expect(tester.takeException(), isNull);

    final moodTab = find.text(AppStrings.mood).first;
    await tester.ensureVisible(moodTab);
    await tester.pumpAndSettle();
    await tester.tap(moodTab);
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.logMoodQuestion), findsOneWidget);
    expect(find.text(AppStrings.saveMoment), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<LocalStorageService> _storage() async {
  SharedPreferences.setMockInitialValues({});
  final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
  await storage.init();
  await storage.saveSettings(
    UserSettings(
      isOnboardingComplete: true,
      userName: 'Test',
      lastPeriodDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
  );
  return storage;
}

class _TestApp extends StatelessWidget {
  final LocalStorageService storage;
  final Future<bool> Function(DailyLog) onSave;

  const _TestApp({required this.storage, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Provider<LocalStorageService>.value(
      value: storage,
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
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: FilledButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => DailyLogSheet(
                      initialLog: DailyLog.empty(DateTime.now()),
                      settings: storage.loadSettings()!,
                      onSave: onSave,
                    ),
                  );
                },
                child: const Text('Aç'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
