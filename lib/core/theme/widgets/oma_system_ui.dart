import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../oma_theme_extension.dart';

class OmaSystemUi extends StatelessWidget {
  const OmaSystemUi({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.omaTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconBrightness = isDark ? Brightness.light : Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: theme.background,
        statusBarIconBrightness: iconBrightness,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarColor: theme.background,
        systemNavigationBarDividerColor: theme.border,
        systemNavigationBarIconBrightness: iconBrightness,
        systemNavigationBarContrastEnforced: false,
      ),
      child: ColoredBox(
        color: theme.background,
        child: SafeArea(top: false, child: child),
      ),
    );
  }
}
