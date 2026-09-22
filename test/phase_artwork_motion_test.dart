import 'package:app_proje_a/core/utils/period_calculator.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/features/home/view/widgets/hero/phase/phase_artwork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final presentation = OmaPhasePresentation.forPhase(CyclePhase.menstrual);

  testWidgets('uses four illustrated blooms from the active phase', (
    tester,
  ) async {
    for (final phase in CyclePhase.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 320,
              height: 408,
              child: PhaseArtwork(
                presentation: OmaPhasePresentation.forPhase(phase),
              ),
            ),
          ),
        ),
      );

      final folder = switch (phase) {
        CyclePhase.menstrual => 'menstrual',
        CyclePhase.follicular => 'follicular',
        CyclePhase.ovulation => 'ovulation',
        CyclePhase.luteal => 'luteal',
      };
      final assets = tester
          .widgetList<Image>(find.byType(Image))
          .map((image) => (image.image as AssetImage).assetName)
          .toSet();
      expect(assets.length, 4);
      expect(
        assets.every(
          (asset) => asset.startsWith(
            'assets/images/decorative/blooms/$folder/phase_bloom_',
          ),
        ),
        isTrue,
      );
    }
  });

  testWidgets('small flowers descend while the hero is visible', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            height: 408,
            child: PhaseArtwork(presentation: presentation),
          ),
        ),
      ),
    );

    final flower = find.byKey(const ValueKey('drifting_flower_0'));
    final anchored = find.byKey(const ValueKey('anchored_flower_0'));
    final initialY = tester.widget<Positioned>(flower).top!;
    final initialX = tester.widget<Positioned>(anchored).left!;
    await tester.pump(const Duration(seconds: 2));
    final laterY = tester.widget<Positioned>(flower).top!;
    final laterX = tester.widget<Positioned>(anchored).left!;

    expect(laterY, greaterThan(initialY));
    expect(laterX, isNot(initialX));
    expect(tester.takeException(), isNull);
  });

  testWidgets('respects reduced motion', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: SizedBox(
              width: 320,
              height: 408,
              child: PhaseArtwork(presentation: presentation),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('drifting_flower_0')), findsNothing);
    final anchored = find.byKey(const ValueKey('anchored_flower_0'));
    final initialX = tester.widget<Positioned>(anchored).left!;
    await tester.pump(const Duration(seconds: 2));
    expect(tester.widget<Positioned>(anchored).left, initialX);
    expect(tester.takeException(), isNull);
  });
}
