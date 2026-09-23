import 'package:flutter/material.dart';

import '../oma_theme_extension.dart';

/// Provides the base themed surface for Oma screens.
///
/// Applies the active theme's background gradient. Decorative background
/// elements should be layered separately.
class OmaSurface extends StatelessWidget {
  const OmaSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.omaTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [theme.background, theme.backgroundAlt],
        ),
      ),
      child: child,
    );
  }
}
