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

    return Container(
      width: containerSize,
      height: containerSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.omaTheme.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: OmaShadows.soft,
      ),
      child: SizedBox(
        width: markSize,
        height: markSize,
        child: Image.asset(ImageConstants.logo, fit: BoxFit.contain),
      ),
    );
  }
}
