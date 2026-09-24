import 'package:flutter/material.dart';

import '../theme/oma_theme.dart';

/// Oma's Material [IconButton] wrapper.
class OmaIconButton extends StatelessWidget {
  const OmaIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.size = 46,
    this.iconSize = 20,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final double size;
  final double iconSize;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;

    return IconButton(
      onPressed: onPressed,
      tooltip: semanticLabel,
      style: IconButton.styleFrom(
        fixedSize: Size.square(size),
        foregroundColor: foregroundColor ?? oma.primary,
        backgroundColor: backgroundColor ?? oma.primarySoft,
        side: borderColor == null ? null : BorderSide(color: borderColor!),
      ),
      icon: Icon(icon, size: iconSize),
    );
  }
}
