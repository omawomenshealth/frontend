import 'package:flutter/material.dart';

import '../constants/image_constants.dart';
import 'oma_theme.dart';

class OmaLogo extends StatelessWidget {
  const OmaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 128,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: OmaColors.card,
        borderRadius: BorderRadius.circular(28),
        boxShadow: OmaShadows.soft,
      ),
      child: SizedBox(
        width: 96,
        height: 96,
        child: Image.asset(
          ImageConstants.logo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}