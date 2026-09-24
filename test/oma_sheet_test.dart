import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('uses the semantic theme surface', (tester) async {
    final oma = OmaThemeResolver.resolve(
      mode: OmaMode.pregnancy,
      brightness: Brightness.dark,
      selectedDate: DateTime(2026, 1, 1),
    );

    await _pumpLauncher(
      tester,
      oma: oma,
      sheetBuilder: (context, controller) =>
          OmaSheet(body: ListView(controller: controller)),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final surface = tester.widget<DecoratedBox>(
      find.byKey(const ValueKey('oma_sheet_surface')),
    );
    final decoration = surface.decoration as BoxDecoration;

    expect(decoration.color, oma.surface);
    expect(decoration.border!.top.color, oma.border);
    expect(
      decoration.borderRadius,
      const BorderRadius.vertical(top: Radius.circular(OmaRadius.xl)),
    );
    expect(decoration.boxShadow, oma.topSheetShadow);
  });

  testWidgets('keeps the footer fixed while the body scrolls', (tester) async {
    await _pumpLauncher(
      tester,
      sheetBuilder: (context, controller) => OmaSheet(
        title: 'Scrollable sheet',
        body: ListView.builder(
          key: const ValueKey('sheet_body'),
          controller: controller,
          itemCount: 50,
          itemBuilder: (context, index) =>
              SizedBox(height: 56, child: Text('Item $index')),
        ),
        footer: const Text('Fixed footer'),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final footerTop = tester.getTopLeft(find.text('Fixed footer')).dy;
    await tester.drag(
      find.byKey(const ValueKey('sheet_body')),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('Fixed footer')).dy, footerTop);
    expect(find.text('Item 0'), findsNothing);
  });

  testWidgets('close button pops the route', (tester) async {
    await _pumpLauncher(
      tester,
      sheetBuilder: (context, controller) => OmaSheet(
        title: 'Closable sheet',
        body: ListView(controller: controller),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('Closable sheet'), findsNothing);
  });

  testWidgets('applies the keyboard view inset', (tester) async {
    await _pumpLauncher(
      tester,
      mediaQueryData: const MediaQueryData(
        size: Size(800, 600),
        viewInsets: EdgeInsets.only(bottom: 180),
      ),
      sheetBuilder: (context, controller) =>
          OmaSheet(body: ListView(controller: controller)),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final insetPadding = tester
        .widgetList<AnimatedPadding>(find.byType(AnimatedPadding))
        .where(
          (widget) => widget.padding == const EdgeInsets.only(bottom: 180),
        );

    expect(insetPadding, hasLength(1));
  });

  testWidgets('forwards a generic result', (tester) async {
    int? result;

    await _pumpLauncher(
      tester,
      onResult: (value) => result = value as int?,
      sheetBuilder: (context, controller) => OmaSheet(
        body: ListView(
          controller: controller,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(42),
              child: const Text('Return value'),
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Return value'));
    await tester.pumpAndSettle();

    expect(result, 42);
  });

  testWidgets('forwards drag and dismiss options to the modal route', (
    tester,
  ) async {
    final observer = _RouteObserver();

    await _pumpLauncher(
      tester,
      observer: observer,
      isDismissible: false,
      enableDrag: false,
      sheetBuilder: (context, controller) =>
          OmaSheet(body: ListView(controller: controller)),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final route = observer.lastRoute! as ModalBottomSheetRoute<Object?>;
    expect(route.isDismissible, isFalse);
    expect(route.enableDrag, isFalse);
    expect(route.isScrollControlled, isTrue);
    expect(route.backgroundColor, Colors.transparent);
  });
}

Future<void> _pumpLauncher(
  WidgetTester tester, {
  required Widget Function(BuildContext, ScrollController) sheetBuilder,
  OmaTheme? oma,
  MediaQueryData? mediaQueryData,
  NavigatorObserver? observer,
  bool isDismissible = true,
  bool enableDrag = true,
  void Function(Object?)? onResult,
}) {
  final app = MaterialApp(
    theme: ThemeData(extensions: [?oma]),
    navigatorObservers: [?observer],
    home: Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () async {
            final result = await showOmaSheet<Object?>(
              context: context,
              isDismissible: isDismissible,
              enableDrag: enableDrag,
              builder: sheetBuilder,
            );
            onResult?.call(result);
          },
          child: const Text('Open'),
        ),
      ),
    ),
  );

  return tester.pumpWidget(
    mediaQueryData == null ? app : MediaQuery(data: mediaQueryData, child: app),
  );
}

class _RouteObserver extends NavigatorObserver {
  Route<dynamic>? lastRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    lastRoute = route;
    super.didPush(route, previousRoute);
  }
}
