import 'package:app_proje_a/core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Projene göre import path'i güncelle.

void main() {
  group('showOmaSheet', () {
    testWidgets('opens and renders sheet content', (tester) async {
      await tester.pumpWidget(
        _TestApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showOmaSheet<void>(
                    context: context,
                    builder: (context, _) {
                      return const OmaSheet(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OmaSheetHeader(
                              title: OmaSheetTitle('Log mood'),
                              description: OmaSheetDescription(
                                'How are you feeling today?',
                              ),
                            ),
                            OmaSheetContent(
                              child: Text('Sheet body'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Log mood'), findsOneWidget);
      expect(
        find.text('How are you feeling today?'),
        findsOneWidget,
      );
      expect(find.text('Sheet body'), findsOneWidget);
    });

    testWidgets('can be dismissed by tapping the barrier', (tester) async {
      await tester.pumpWidget(
        _TestApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showOmaSheet<void>(
                    context: context,
                    builder: (context, _) {
                      return const OmaSheet(
                        child: OmaSheetContent(
                          child: Text('Sheet body'),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Sheet body'), findsOneWidget);

      // Tap outside the modal sheet.
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      expect(find.text('Sheet body'), findsNothing);
    });

    testWidgets(
      'does not dismiss from barrier when isDismissible is false',
      (tester) async {
        await tester.pumpWidget(
          _TestApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showOmaSheet<void>(
                      context: context,
                      isDismissible: false,
                      builder: (context, _) {
                        return const OmaSheet(
                          child: OmaSheetContent(
                            child: Text('Persistent sheet'),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        await tester.tapAt(const Offset(20, 20));
        await tester.pumpAndSettle();

        expect(find.text('Persistent sheet'), findsOneWidget);
      },
    );

    testWidgets('supports returning a result', (tester) async {
      String? result;

      await tester.pumpWidget(
        _TestApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await showOmaSheet<String>(
                    context: context,
                    builder: (context, _) {
                      return OmaSheet(
                        child: OmaSheetContent(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop('saved');
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(result, 'saved');
    });
  });

  group('OmaSheetHeader', () {
    testWidgets('renders title and description', (tester) async {
      await tester.pumpWidget(
        const _TestApp(
          child: OmaSheet(
            child: OmaSheetHeader(
              title: OmaSheetTitle('Symptoms'),
              description: OmaSheetDescription(
                'Select everything that applies.',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Symptoms'), findsOneWidget);
      expect(
        find.text('Select everything that applies.'),
        findsOneWidget,
      );
    });

    testWidgets('renders leading and trailing widgets', (tester) async {
      await tester.pumpWidget(
        const _TestApp(
          child: OmaSheet(
            child: OmaSheetHeader(
              leading: Icon(
                Icons.favorite,
                key: ValueKey('leading'),
              ),
              title: OmaSheetTitle('Title'),
              trailing: Icon(
                Icons.info,
                key: ValueKey('trailing'),
              ),
              showCloseButton: false,
            ),
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey('leading')),
        findsOneWidget,
      );

      expect(
        find.byKey(const ValueKey('trailing')),
        findsOneWidget,
      );
    });

    testWidgets(
      'does not render close button when showCloseButton is false',
      (tester) async {
        await tester.pumpWidget(
          const _TestApp(
            child: OmaSheet(
              child: OmaSheetHeader(
                title: OmaSheetTitle('Title'),
                showCloseButton: false,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.close), findsNothing);
      },
    );
  });

  group('OmaSheetClose', () {
    testWidgets('closes the current sheet', (tester) async {
      await tester.pumpWidget(
        _TestApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showOmaSheet<void>(
                    context: context,
                    builder: (context, _) {
                      return const OmaSheet(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OmaSheetHeader(
                              title: OmaSheetTitle('Sheet'),
                            ),
                            OmaSheetContent(
                              child: Text('Content'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Content'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Content'), findsNothing);
    });

    testWidgets('returns its configured result', (tester) async {
      String? result;

      await tester.pumpWidget(
        _TestApp(
          child: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await showOmaSheet<String>(
                    context: context,
                    builder: (context, _) {
                      return const OmaSheet(
                        child: OmaSheetHeader(
                          title: OmaSheetTitle('Sheet'),
                          trailing: OmaSheetClose<String>(
                            result: 'closed',
                          ),
                          showCloseButton: false,
                        ),
                      );
                    },
                  );
                },
                child: const Text('Open'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(result, 'closed');
    });
  });

  group('OmaSheetContent', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        const _TestApp(
          child: OmaSheetContent(
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('applies custom padding', (tester) async {
      const padding = EdgeInsets.all(42);

      await tester.pumpWidget(
        const _TestApp(
          child: OmaSheetContent(
            padding: padding,
            child: Text('Content'),
          ),
        ),
      );

      final paddingWidget = tester.widget<Padding>(
        find.ancestor(
          of: find.text('Content'),
          matching: find.byType(Padding),
        ).first,
      );

      expect(paddingWidget.padding, padding);
    });
  });

  group('OmaSheetFooter', () {
    testWidgets('renders footer content', (tester) async {
      await tester.pumpWidget(
        const _TestApp(
          child: OmaSheetFooter(
            child: Text('Save'),
          ),
        ),
      );

      expect(find.text('Save'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('oma_sheet_footer')),
        findsOneWidget,
      );
    });

    testWidgets('can hide divider', (tester) async {
      await tester.pumpWidget(
        const _TestApp(
          child: OmaSheetFooter(
            showDivider: false,
            child: Text('Save'),
          ),
        ),
      );

      final decoratedBox = tester.widget<DecoratedBox>(
        find.byKey(const ValueKey('oma_sheet_footer')),
      );

      final decoration =
          decoratedBox.decoration as BoxDecoration;

      expect(decoration.border, isNull);
    });

    testWidgets('renders divider by default', (tester) async {
      await tester.pumpWidget(
        const _TestApp(
          child: OmaSheetFooter(
            child: Text('Save'),
          ),
        ),
      );

      final decoratedBox = tester.widget<DecoratedBox>(
        find.byKey(const ValueKey('oma_sheet_footer')),
      );

      final decoration =
          decoratedBox.decoration as BoxDecoration;

      expect(decoration.border, isNotNull);
    });
  });

  group('draggable Oma sheet', () {
    testWidgets(
      'provides DraggableScrollableSheet controller to builder',
      (tester) async {
        ScrollController? receivedController;

        await tester.pumpWidget(
          _TestApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showOmaSheet<void>(
                      context: context,
                      dragConfiguration:
                          const OmaSheetDragConfiguration(),
                      builder: (context, scrollController) {
                        receivedController = scrollController;

                        return OmaSheet(
                          child: ListView(
                            controller: scrollController,
                            children: const [
                              OmaSheetHeader(
                                title: OmaSheetTitle(
                                  'Draggable sheet',
                                ),
                              ),
                              OmaSheetContent(
                                child: Text('Content'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(receivedController, isNotNull);

        expect(
          find.byType(DraggableScrollableSheet),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'does not create DraggableScrollableSheet without configuration',
      (tester) async {
        ScrollController? receivedController;

        await tester.pumpWidget(
          _TestApp(
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    showOmaSheet<void>(
                      context: context,
                      builder: (context, scrollController) {
                        receivedController = scrollController;

                        return const OmaSheet(
                          child: OmaSheetContent(
                            child: Text('Normal sheet'),
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(receivedController, isNull);

        expect(
          find.byType(DraggableScrollableSheet),
          findsNothing,
        );
      },
    );
  });

  group('keyboard handling', () {
    testWidgets(
      'adds bottom padding based on keyboard viewInsets',
      (tester) async {
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(
              viewInsets: EdgeInsets.only(bottom: 300),
            ),
            child: _TestApp(
              child: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      showOmaSheet<void>(
                        context: context,
                        builder: (context, _) {
                          return const OmaSheet(
                            child: OmaSheetContent(
                              child: TextField(),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Open'),
                  );
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pump();

        final animatedPadding = tester.widget<AnimatedPadding>(
          find
              .descendant(
                of: find.byType(BottomSheet),
                matching: find.byType(AnimatedPadding),
              )
              .first,
        );

        expect(
          animatedPadding.padding,
          const EdgeInsets.only(bottom: 300),
        );
      },
    );
  });
}

/// Minimal Material host used by the widget tests.
///
/// Replace the theme configuration with the project's real Oma theme builder
/// if `context.omaTheme` requires a custom ThemeExtension.
class _TestApp extends StatelessWidget {
  const _TestApp({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // If OmaTheme is registered through ThemeData.extensions, use the
      // production theme here, for example:
      //
      // theme: buildOmaTheme(...),
      //
      home: Scaffold(
        body: Center(
          child: child,
        ),
      ),
    );
  }
}
