import 'package:flutter/material.dart';

import '../oma_theme_extension.dart';

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
