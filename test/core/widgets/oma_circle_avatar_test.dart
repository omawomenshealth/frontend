import 'dart:convert';

import 'package:app_proje_a/core/theme/app_theme.dart';
import 'package:app_proje_a/core/theme/oma_theme.dart';
import 'package:app_proje_a/core/widgets/oma_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('forwards child and sizing to CircleAvatar', (tester) async {
    await _pump(tester, const OmaCircleAvatar(radius: 24, child: Text('R')));

    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(avatar.radius, 24);
    expect(find.text('R'), findsOneWidget);
  });

  testWidgets('forwards background image configuration', (tester) async {
    final image = MemoryImage(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=',
      ),
    );

    await _pump(tester, OmaCircleAvatar(backgroundImage: image));

    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(avatar.backgroundImage, same(image));
  });

  testWidgets('inherits Oma semantic colors through Material ColorScheme', (
    tester,
  ) async {
    final oma = _omaTheme();
    await _pump(tester, const OmaCircleAvatar(child: Text('R')), oma: oma);

    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    final theme = Theme.of(tester.element(find.byType(CircleAvatar)));

    expect(avatar.backgroundColor, isNull);
    expect(avatar.foregroundColor, isNull);
    expect(theme.colorScheme.primaryContainer, oma.primarySoft);
    expect(theme.colorScheme.onPrimaryContainer, oma.primaryStrong);
  });
}

Future<void> _pump(WidgetTester tester, Widget child, {OmaTheme? oma}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.fromOmaTheme(oma ?? _omaTheme()),
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
