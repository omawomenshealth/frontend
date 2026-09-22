import 'package:flutter/material.dart';

import 'oma_theme.dart';

class OmaDivider extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const OmaDivider({
    super.key,
    this.width = double.infinity,
    this.height = 1,
    this.color,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    height: height,
    child: ColoredBox(color: color ?? OmaColors.border),
  );
}
