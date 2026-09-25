import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_dialog.dart';
import 'package:app_proje_a/core/widgets/oma_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DialogThemeData uses Oma surface tokens', () {
    final oma = _omaTheme();
    final dialogTheme = AppTheme.fromOmaTheme(oma).dialogTheme;
    final shape = dialogTheme.shape! as RoundedRectangleBorder;

    expect(dialogTheme.backgroundColor, oma.surface);
    expect(dialogTheme.surfaceTintColor, Colors.transparent);
    expect(dialogTheme.elevation, OmaSpacing.sm);
    expect(dialogTheme.shadowColor, oma.shadow);
    expect(dialogTheme.clipBehavior, Clip.antiAlias);
    expect(shape.side.color, oma.border);
    expect(shape.borderRadius, BorderRadius.circular(OmaRadius.xl));
  });

  testWidgets('showOmaDialog opens and renders a realistic composition', (
    tester,
  ) async {
    await _pumpLauncher(
      tester,
      dialogBuilder: (context) => const OmaDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OmaDialogHeader(
              title: OmaDialogTitle('Delete entry?'),
              description: OmaDialogDescription('This cannot be undone.'),
            ),
            OmaDialogContent(child: Text('Dialog content')),
            OmaDialogFooter(child: Text('Dialog actions')),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Delete entry?'), findsOneWidget);
    expect(find.text('This cannot be undone.'), findsOneWidget);
    expect(find.text('Dialog content'), findsOneWidget);
    expect(find.text('Dialog actions'), findsOneWidget);
  });

  testWidgets('dismissible barrier closes the dialog', (tester) async {
    await _pumpLauncher(
      tester,
      dialogBuilder: (context) => const OmaDialog(
        child: SizedBox(height: 120, child: Text('Dismissible dialog')),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.text('Dismissible dialog'), findsNothing);
  });

  testWidgets('non-dismissible barrier keeps the dialog open', (tester) async {
    await _pumpLauncher(
      tester,
      barrierDismissible: false,
      dialogBuilder: (context) => const OmaDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OmaDialogHeader(title: OmaDialogTitle('Blocking dialog')),
            OmaDialogContent(child: Text('Required choice')),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.text('Blocking dialog'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
  });

  testWidgets('header renders optional slots and can hide close action', (
    tester,
  ) async {
    await _pumpLauncher(
      tester,
      dialogBuilder: (context) => const OmaDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OmaDialogHeader(
              title: OmaDialogTitle('Title'),
              description: OmaDialogDescription('Description'),
              leading: Icon(Icons.info_outline, key: ValueKey('leading')),
              trailing: SizedBox(key: ValueKey('trailing')),
              showCloseButton: false,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.byKey(const ValueKey('leading')), findsOneWidget);
    expect(find.byKey(const ValueKey('trailing')), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('OmaDialogClose returns a generic result', (tester) async {
    String? result;

    await _pumpLauncher(
      tester,
      onResult: (value) => result = value as String?,
      dialogBuilder: (context) => const OmaDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OmaDialogHeader(
              title: OmaDialogTitle('Result dialog'),
              trailing: OmaDialogClose<String>(result: 'closed'),
              showCloseButton: false,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(result, 'closed');
    expect(find.text('Result dialog'), findsNothing);
  });

  testWidgets('content renders its child with custom padding', (tester) async {
    const padding = EdgeInsets.all(7);

    await _pumpDirect(
      tester,
      const OmaDialogContent(
        key: ValueKey('content'),
        padding: padding,
        child: Text('Padded content'),
      ),
    );

    final content = tester.widget<OmaDialogContent>(
      find.byKey(const ValueKey('content')),
    );
    expect(content.padding, padding);
    expect(find.text('Padded content'), findsOneWidget);
  });

  testWidgets('footer can show or hide its divider', (tester) async {
    await _pumpDirect(
      tester,
      const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OmaDialogFooter(
            key: ValueKey('with_divider'),
            child: Text('With divider'),
          ),
          OmaDialogFooter(
            key: ValueKey('without_divider'),
            showDivider: false,
            child: Text('Without divider'),
          ),
        ],
      ),
    );

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('with_divider')),
        matching: find.byType(OmaDivider),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('without_divider')),
        matching: find.byType(OmaDivider),
      ),
      findsNothing,
    );
  });

  testWidgets('confirmation convenience returns the selected result', (
    tester,
  ) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.fromOmaTheme(_omaTheme()),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await showOmaConfirmationDialog(
                context: context,
                title: 'Confirm',
                description: 'Continue?',
                confirmLabel: 'Yes',
                cancelLabel: 'No',
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });
}

Future<void> _pumpLauncher(
  WidgetTester tester, {
  required WidgetBuilder dialogBuilder,
  bool barrierDismissible = true,
  void Function(Object?)? onResult,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.fromOmaTheme(_omaTheme()),
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async {
              final result = await showOmaDialog<Object?>(
                context: context,
                barrierDismissible: barrierDismissible,
                builder: dialogBuilder,
              );
              onResult?.call(result);
            },
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
}

Future<void> _pumpDirect(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.fromOmaTheme(_omaTheme()),
      home: Scaffold(body: child),
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
