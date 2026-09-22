import 'package:app_proje_a/core/widgets/oma_sunburst.dart';
import 'package:app_proje_a/core/widgets/oma_theme.dart';
import 'package:app_proje_a/shell/widgets/oma_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('bottom navigation aktif faz rengini kullanır', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: OmaBottomNavigation(
            currentIndex: 0,
            onTap: (_) {},
            onOmaTap: () {},
            activeColor: OmaColors.periodPrimary,
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
    expect(navigation.selectedItemColor, OmaColors.periodPrimary);
    expect(
      tester.widget<OmaSunburst>(find.byType(OmaSunburst)).color,
      OmaColors.periodPrimary,
    );
  });
}
