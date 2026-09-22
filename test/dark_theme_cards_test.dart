import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/data/models/period_log_model.dart';
import 'package:app_proje_a/views/dashboard/widgets/medication_checklist_card.dart';
import 'package:app_proje_a/views/dashboard/widgets/mood_selector_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final dark = OmaThemeResolver.resolve(
    mode: OmaMode.cycle,
    brightness: Brightness.dark,
    selectedDate: DateTime(2026, 1, 1),
  );

  Future<void> pumpCards(WidgetTester tester) async {
    final theme = AppTheme.fromOmaTheme(dark);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        darkTheme: theme,
        themeMode: ThemeMode.dark,
        home: Scaffold(
          body: Column(
            children: [
              MoodSelectorCard(onMoodSelected: (_) {}),
              MedicationChecklistCard(
                title: 'İlaçlar',
                icon: Icons.medication_outlined,
                color: dark.primary,
                items: const <MedicationEntry>[],
                onToggle: (_) {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('dashboard cards use the resolved dark surface', (tester) async {
    await pumpCards(tester);

    final darkSurfaces = find.byWidgetPredicate((widget) {
      if (widget is! Container || widget.decoration is! BoxDecoration) {
        return false;
      }
      return (widget.decoration! as BoxDecoration).color == dark.surface;
    });

    expect(darkSurfaces, findsNWidgets(2));
    expect(
      find.byWidgetPredicate((widget) {
        if (widget is! Container || widget.decoration is! BoxDecoration) {
          return false;
        }
        return (widget.decoration! as BoxDecoration).color == OmaPalette.card;
      }),
      findsNothing,
    );
  });
}
