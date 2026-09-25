import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Oma tabs composition', () {
    testWidgets('maps trigger values to content and native selection', (
      tester,
    ) async {
      String? selectedValue;
      await _pump(
        tester,
        OmaTabs<String>(
          defaultValue: 'account',
          onValueChanged: (value) => selectedValue = value,
          children: const [
            OmaTabsList<String>(
              children: [
                OmaTabsTrigger<String>(value: 'account', text: 'Account'),
                OmaTabsTrigger<String>(value: 'password', text: 'Password'),
              ],
            ),
            OmaTabsContent<String>(
              value: 'account',
              child: Text('Account content'),
            ),
            OmaTabsContent<String>(
              value: 'password',
              child: Text('Password content'),
            ),
          ],
        ),
      );

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller, isA<TabController>());
      expect(tabBar.controller!.index, 0);
      expect(find.text('Account content').hitTestable(), findsOneWidget);
      expect(find.text('Password content').hitTestable(), findsNothing);

      await tester.tap(find.text('Password'));
      await tester.pumpAndSettle();

      expect(tabBar.controller!.index, 1);
      expect(selectedValue, 'password');
      expect(find.text('Account content').hitTestable(), findsNothing);
      expect(find.text('Password content').hitTestable(), findsOneWidget);
    });

    testWidgets('uses defaultValue as the initial native tab index', (
      tester,
    ) async {
      await _pump(
        tester,
        const OmaTabs<String>(
          defaultValue: 'password',
          children: [
            OmaTabsList<String>(
              children: [
                OmaTabsTrigger<String>(value: 'account', text: 'Account'),
                OmaTabsTrigger<String>(value: 'password', text: 'Password'),
              ],
            ),
            OmaTabsContent<String>(
              value: 'account',
              child: Text('Account content'),
            ),
            OmaTabsContent<String>(
              value: 'password',
              child: Text('Password content'),
            ),
          ],
        ),
      );

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller!.index, 1);
      expect(find.text('Password content').hitTestable(), findsOneWidget);
    });

    testWidgets('triggers remain native Tab instances with icon composition', (
      tester,
    ) async {
      const triggers = [
        OmaTabsTrigger<String>(
          value: 'overview',
          text: 'Overview',
          icon: Icon(Icons.home_outlined),
        ),
        OmaTabsTrigger<String>(
          value: 'history',
          text: 'History',
          icon: Icon(Icons.history_rounded),
        ),
      ];

      await _pump(
        tester,
        const OmaTabs<String>(
          defaultValue: 'overview',
          children: [OmaTabsList<String>(children: triggers)],
        ),
      );

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.tabs, same(triggers));
      expect(tabBar.tabs, everyElement(isA<Tab>()));
      expect(triggers.first.text, 'Overview');
      expect(triggers.first.icon, isA<Icon>());
    });

    testWidgets('inherits the production TabBarThemeData', (tester) async {
      final oma = _omaTheme();
      await _pump(tester, _basicTabs(variant: OmaTabsVariant.line), oma: oma);

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      final theme = TabBarTheme.of(tester.element(find.byType(TabBar)));
      expect(tabBar.labelColor, isNull);
      expect(tabBar.unselectedLabelColor, isNull);
      expect(tabBar.indicator, isNull);
      expect(theme.indicatorColor, oma.primary);
      expect(theme.indicatorSize, TabBarIndicatorSize.tab);
      expect(theme.dividerColor, oma.divider);
      expect(theme.labelColor, oma.foreground);
      expect(theme.unselectedLabelColor, oma.muted);
      expect(theme.indicatorAnimation, TabIndicatorAnimation.linear);
    });

    testWidgets('contained list resolves its visuals from OmaTheme', (
      tester,
    ) async {
      final oma = _omaTheme();
      await _pump(tester, _basicTabs(), oma: oma);

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      final indicator = tabBar.indicator! as BoxDecoration;
      expect(indicator.color, oma.surface);
      expect(indicator.borderRadius, BorderRadius.circular(OmaRadius.md));
      expect(indicator.boxShadow, oma.softShadow);
      expect(tabBar.indicatorSize, TabBarIndicatorSize.tab);
      expect(tabBar.dividerHeight, OmaSpacing.none);
      expect(
        tabBar.labelPadding,
        const EdgeInsets.symmetric(horizontal: OmaSpacing.xs),
      );
      expect(tabBar.splashBorderRadius, BorderRadius.circular(OmaRadius.md));

      final themedContainer = tester
          .widgetList<Container>(find.byType(Container))
          .singleWhere(
            (container) =>
                (container.decoration as BoxDecoration?)?.color ==
                oma.backgroundAlt,
          );
      final decoration = themedContainer.decoration! as BoxDecoration;
      expect(themedContainer.padding, const EdgeInsets.all(OmaSpacing.xs));
      expect(decoration.borderRadius, BorderRadius.circular(OmaRadius.lg));
      expect(decoration.border, isNotNull);
    });

    testWidgets('list forwards native visual and interaction overrides', (
      tester,
    ) async {
      final scrollController = TabBarScrollController();
      addTearDown(scrollController.dispose);
      const indicator = BoxDecoration(color: Colors.amber);
      const labelStyle = TextStyle(fontSize: 16);
      const unselectedStyle = TextStyle(fontSize: 14);
      const overlay = WidgetStatePropertyAll<Color?>(Colors.purple);
      const padding = EdgeInsets.all(3);
      const indicatorPadding = EdgeInsets.all(2);
      const labelPadding = EdgeInsets.symmetric(horizontal: 6);
      const physics = BouncingScrollPhysics();
      const splashRadius = BorderRadius.all(Radius.circular(9));
      const decoration = BoxDecoration(color: Colors.black12);

      await _pump(
        tester,
        OmaTabs<String>(
          defaultValue: 'overview',
          children: [
            OmaTabsList<String>(
              scrollController: scrollController,
              isScrollable: true,
              padding: padding,
              indicator: indicator,
              indicatorColor: Colors.red,
              automaticIndicatorColorAdjustment: false,
              indicatorWeight: 4,
              indicatorPadding: indicatorPadding,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.blue,
              dividerHeight: 3,
              labelColor: Colors.green,
              labelStyle: labelStyle,
              labelPadding: labelPadding,
              unselectedLabelColor: Colors.orange,
              unselectedLabelStyle: unselectedStyle,
              overlayColor: overlay,
              mouseCursor: SystemMouseCursors.click,
              enableFeedback: false,
              physics: physics,
              splashFactory: NoSplash.splashFactory,
              splashBorderRadius: splashRadius,
              tabAlignment: TabAlignment.start,
              textScaler: TextScaler.noScaling,
              indicatorAnimation: TabIndicatorAnimation.elastic,
              margin: const EdgeInsets.all(5),
              contentPadding: const EdgeInsets.all(4),
              decoration: decoration,
              children: const [
                OmaTabsTrigger<String>(value: 'overview', text: 'Overview'),
                OmaTabsTrigger<String>(value: 'history', text: 'History'),
              ],
            ),
          ],
        ),
      );

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller, isA<TabController>());
      expect(tabBar.scrollController, same(scrollController));
      expect(tabBar.isScrollable, isTrue);
      expect(tabBar.padding, padding);
      expect(tabBar.indicator, indicator);
      expect(tabBar.indicatorColor, Colors.red);
      expect(tabBar.automaticIndicatorColorAdjustment, isFalse);
      expect(tabBar.indicatorWeight, 4);
      expect(tabBar.indicatorPadding, indicatorPadding);
      expect(tabBar.indicatorSize, TabBarIndicatorSize.label);
      expect(tabBar.dividerColor, Colors.blue);
      expect(tabBar.dividerHeight, 3);
      expect(tabBar.labelColor, Colors.green);
      expect(tabBar.labelStyle, labelStyle);
      expect(tabBar.labelPadding, labelPadding);
      expect(tabBar.unselectedLabelColor, Colors.orange);
      expect(tabBar.unselectedLabelStyle, unselectedStyle);
      expect(tabBar.overlayColor, same(overlay));
      expect(tabBar.mouseCursor, SystemMouseCursors.click);
      expect(tabBar.enableFeedback, isFalse);
      expect(tabBar.physics, physics);
      expect(tabBar.splashFactory, NoSplash.splashFactory);
      expect(tabBar.splashBorderRadius, splashRadius);
      expect(tabBar.tabAlignment, TabAlignment.start);
      expect(tabBar.textScaler, TextScaler.noScaling);
      expect(tabBar.indicatorAnimation, TabIndicatorAnimation.elastic);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('forwards hover and focus callbacks', (tester) async {
      bool? hoverValue;
      int? hoverIndex;
      bool? focusValue;
      int? focusIndex;

      await _pump(
        tester,
        OmaTabs<String>(
          defaultValue: 'overview',
          children: [
            OmaTabsList<String>(
              onHover: (value, index) {
                hoverValue = value;
                hoverIndex = index;
              },
              onFocusChange: (value, index) {
                focusValue = value;
                focusIndex = index;
              },
              children: const [
                OmaTabsTrigger<String>(value: 'overview', text: 'Overview'),
                OmaTabsTrigger<String>(value: 'history', text: 'History'),
              ],
            ),
          ],
        ),
      );

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      tabBar.onHover!(true, 1);
      tabBar.onFocusChange!(true, 0);
      expect((hoverValue, hoverIndex), (true, 1));
      expect((focusValue, focusIndex), (true, 0));
    });

    testWidgets('secondary list uses the native secondary contract', (
      tester,
    ) async {
      await _pump(
        tester,
        const OmaTabs<String>(
          defaultValue: 'overview',
          children: [
            OmaTabsList<String>.secondary(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorAnimation: TabIndicatorAnimation.elastic,
              children: [
                OmaTabsTrigger<String>(value: 'overview', text: 'Overview'),
                OmaTabsTrigger<String>(value: 'history', text: 'History'),
              ],
            ),
          ],
        ),
      );

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller, isA<TabController>());
      expect(tabBar.isScrollable, isTrue);
      expect(tabBar.tabAlignment, TabAlignment.start);
      expect(tabBar.indicatorAnimation, TabIndicatorAnimation.elastic);
    });
  });

  test('all Oma themes configure semantic tab colors', () {
    for (final mode in OmaMode.values) {
      for (final brightness in Brightness.values) {
        final oma = _omaTheme(mode: mode, brightness: brightness);
        final tabs = AppTheme.fromOmaTheme(oma).tabBarTheme;

        expect(tabs.indicatorColor, oma.primary);
        expect(tabs.dividerColor, oma.divider);
        expect(tabs.labelColor, oma.foreground);
        expect(tabs.unselectedLabelColor, oma.muted);
        expect(
          tabs.overlayColor?.resolve({WidgetState.hovered}),
          oma.primary.withValues(alpha: 0.08),
        );
      }
    }
  });
}

Widget _basicTabs({OmaTabsVariant variant = OmaTabsVariant.contained}) {
  return OmaTabs<String>(
    defaultValue: 'overview',
    children: [
      OmaTabsList<String>(
        variant: variant,
        children: const [
          OmaTabsTrigger<String>(value: 'overview', text: 'Overview'),
          OmaTabsTrigger<String>(value: 'history', text: 'History'),
        ],
      ),
    ],
  );
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

OmaTheme _omaTheme({
  OmaMode mode = OmaMode.cycle,
  Brightness brightness = Brightness.light,
}) {
  return OmaThemeResolver.resolve(
    mode: mode,
    brightness: brightness,
    selectedDate: DateTime(2026, 1, 1),
  );
}
