import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_wrap.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders children with Oma spacing defaults', (tester) async {
    await _pump(tester, const OmaWrap(children: [Text('One'), Text('Two')]));

    final wrap = tester.widget<Wrap>(find.byType(Wrap));
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(wrap.spacing, OmaSpacing.sm);
    expect(wrap.runSpacing, OmaSpacing.sm);
  });

  testWidgets('forwards spacing, direction and alignment overrides', (
    tester,
  ) async {
    await _pump(
      tester,
      const OmaWrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.end,
        spacing: 20,
        runSpacing: 12,
        children: [Text('One')],
      ),
    );

    final wrap = tester.widget<Wrap>(find.byType(Wrap));
    expect(wrap.direction, Axis.vertical);
    expect(wrap.alignment, WrapAlignment.center);
    expect(wrap.runAlignment, WrapAlignment.end);
    expect(wrap.spacing, 20);
    expect(wrap.runSpacing, 12);
  });
}

Future<void> _pump(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    Directionality(textDirection: TextDirection.ltr, child: child),
  );
}
