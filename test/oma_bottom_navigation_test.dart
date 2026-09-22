import 'package:app_proje_a/core/widgets/oma_sunburst.dart';
import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/utils/period_calculator.dart';
import 'package:app_proje_a/shell/widgets/oma_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('bottom navigation aktif faz rengini kullanır', (tester) async {
    final phaseColor = OmaCycleSchemes.forPhase(CyclePhase.menstrual).primary;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          bottomNavigationBar: OmaBottomNavigation(
            currentIndex: 0,
            onTap: (_) {},
            onOmaTap: () {},
            activeColor: phaseColor,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Ana Sayfa',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );

    final navigation = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(navigation.selectedItemColor, phaseColor);
    expect(
      tester.widget<OmaSunburst>(find.byType(OmaSunburst)).color,
      phaseColor,
    );
  });
}
