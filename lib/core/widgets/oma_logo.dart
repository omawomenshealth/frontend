import 'package:flutter/material.dart';

import '../constants/image_constants.dart';
import '../theme/oma_theme.dart';

const _standardLogoRadius = 28.0;

enum OmaLogoSize { compact, standard }

class OmaLogo extends StatelessWidget {
  const OmaLogo({super.key, this.size = OmaLogoSize.standard});

  final OmaLogoSize size;

  @override
  Widget build(BuildContext context) {
    final (containerSize, markSize, radius) = switch (size) {
      OmaLogoSize.compact => (80.0, 40.0, OmaRadius.xl),
      OmaLogoSize.standard => (128.0, 96.0, _standardLogoRadius),
    };

    final theme = context.omaTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final logoAsset = isDark
        ? ImageConstants.logoDark
        : ImageConstants.logoLight;

    return Container(
      width: containerSize,
      height: containerSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.logoSurface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: theme.softShadow,
      ),
      child: SizedBox(
        width: markSize,
        height: markSize,
        child: Image.asset(logoAsset, fit: BoxFit.contain),
      ),
    );
  }
}
