import 'package:app_proje_a/core/constants/app_strings.dart';
import 'package:app_proje_a/core/constants/color_constants.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/data/models/user_settings_model.dart';
import 'package:app_proje_a/data/services/local_encrypted_store.dart';
import 'package:app_proje_a/data/services/local_storage_service.dart';
import 'package:app_proje_a/features/tracking/application/tracking_controller.dart';
import 'package:app_proje_a/features/tracking/domain/models/tracking_section.dart';
import 'package:app_proje_a/features/tracking/presentation/daily_log_sheet.dart';
import 'package:app_proje_a/features/tracking/presentation/tracking_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Each quick action opens only its independent sheet widget', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final storage = LocalStorageService(keyStore: MemoryLocalKeyStore());
    await storage.init();
    final settings = UserSettings(
      isOnboardingComplete: true,
      lastPeriodDate: DateTime.now().subtract(const Duration(days: 8)),
    );
    await storage.saveSettings(settings);
    final tracking = TrackingController.local(storage);
    addTearDown(tracking.dispose);

    const sections = TrackingSection.values;
    const sheetTypes = <Type>[
      PeriodTrackingSheet,
      NutritionTrackingSheet,
      SymptomsTrackingSheet,
      WellbeingTrackingSheet,
      MedicationTrackingSheet,
      SkincareTrackingSheet,
    ];

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<LocalStorageService>.value(value: storage),
          ChangeNotifierProvider<TrackingController>.value(value: tracking),
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
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  for (final section in sections)
                    TextButton(
                      onPressed: () => TrackingLauncher.open(
                        context,
                        section: section,
                        date: DateTime.now(),
                        settings: settings,
                        themeColor: AppColors.primary,
                      ),
                      child: Text('Open ${section.name}'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    for (var index = 0; index < sections.length; index++) {
      await tester.tap(find.text('Open ${sections[index].name}'));
      await tester.pumpAndSettle();
      expect(find.byType(sheetTypes[index]), findsOneWidget);
      for (var other = 0; other < sheetTypes.length; other++) {
        if (other != index) {
          expect(find.byType(sheetTypes[other]), findsNothing);
        }
      }
      await tester.tap(find.byTooltip(AppStrings.close));
      await tester.pumpAndSettle();
    }
  });
}
