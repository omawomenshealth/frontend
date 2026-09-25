import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a label', (tester) async {
    await _pump(tester, const OmaBadge(label: Text('New')));
    expect(find.text('New'), findsOneWidget);
  });

  testWidgets('renders a child', (tester) async {
    await _pump(
      tester,
      const OmaBadge(child: Icon(Icons.notifications_outlined)),
    );
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
  });

  testWidgets('renders label and child together', (tester) async {
    await _pump(
      tester,
      const OmaBadge(
        label: Text('3'),
        child: Icon(Icons.notifications_outlined),
      ),
    );
    expect(find.text('3'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
  });

  testWidgets('null label uses the native small badge', (tester) async {
    await _pump(
      tester,
      const OmaBadge(child: Icon(Icons.notifications_outlined)),
    );
    final badge = tester.widget<Badge>(find.byType(Badge));
    expect(badge.label, isNull);
    expect(badge.child, isA<Icon>());
  });

  testWidgets('isLabelVisible is passed to Material Badge', (tester) async {
    await _pump(
      tester,
      const OmaBadge(
        label: Text('3'),
        isLabelVisible: false,
        child: Icon(Icons.notifications_outlined),
      ),
    );
    final badge = tester.widget<Badge>(find.byType(Badge));
    expect(badge.isLabelVisible, isFalse);
    expect(find.text('3'), findsNothing);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
  });

  testWidgets('alignment and offset are passed to Material Badge', (
    tester,
  ) async {
    const alignment = Alignment.bottomLeft;
    const offset = Offset(2, 3);
    await _pump(
      tester,
      const OmaBadge(label: Text('3'), alignment: alignment, offset: offset),
    );
    final badge = tester.widget<Badge>(find.byType(Badge));
    expect(badge.alignment, alignment);
    expect(badge.offset, offset);
  });

  testWidgets('uses Oma badge theme defaults', (tester) async {
    final oma = _omaTheme();
    await _pump(tester, const OmaBadge(label: Text('3')), oma: oma);
    final context = tester.element(find.byType(Badge));
    final badge = tester.widget<Badge>(find.byType(Badge));
    final theme = BadgeTheme.of(context);
    expect(badge.backgroundColor, isNull);
    expect(badge.textColor, isNull);
    expect(theme.backgroundColor, oma.error);
    expect(theme.textColor, oma.onPrimary);
    expect(theme.smallSize, OmaSpacing.sm);
    expect(theme.largeSize, OmaSpacing.xl);
  });

  testWidgets('explicit styling overrides remain on Material Badge', (
    tester,
  ) async {
    const background = Colors.teal;
    const foreground = Colors.amber;
    await _pump(
      tester,
      const OmaBadge(
        label: Text('3'),
        backgroundColor: background,
        textColor: foreground,
      ),
    );
    final badge = tester.widget<Badge>(find.byType(Badge));
    expect(badge.backgroundColor, background);
    expect(badge.textColor, foreground);
  });

  group('OmaBadge.count', () {
    testWidgets('uses native count formatting and renders its child', (
      tester,
    ) async {
      await _pump(
        tester,
        const OmaBadge.count(
          count: 132,
          maxCount: 99,
          child: Icon(Icons.mail_outline),
        ),
      );
      expect(find.text('99+'), findsOneWidget);
      expect(find.text('132'), findsNothing);
      expect(find.byIcon(Icons.mail_outline), findsOneWidget);
    });

    testWidgets('passes visibility to native count badge', (tester) async {
      await _pump(
        tester,
        const OmaBadge.count(
          count: 3,
          isLabelVisible: false,
          child: Icon(Icons.mail_outline),
        ),
      );
      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.isLabelVisible, isFalse);
      expect(find.text('3'), findsNothing);
      expect(find.byIcon(Icons.mail_outline), findsOneWidget);
    });
  });
}

Future<void> _pump(WidgetTester tester, Widget child, {OmaTheme? oma}) {
  final effectiveTheme = oma ?? _omaTheme();
  return tester.pumpWidget(
    MaterialApp(
      themeAnimationDuration: Duration.zero,
      theme: AppTheme.fromOmaTheme(effectiveTheme),
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

OmaTheme _omaTheme() {
  return OmaThemeResolver.resolve(
    mode: OmaMode.cycle,
    brightness: Brightness.light,
    selectedDate: DateTime(2026, 1, 1),
  );
}
