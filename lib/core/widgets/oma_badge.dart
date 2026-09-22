import 'package:flutter/material.dart';

import '../theme/oma_theme.dart';

enum OmaBadgeLabelVariant { standard, eyebrow }

class OmaBadge extends StatelessWidget {
  const OmaBadge({
    super.key,
    this.icon,
    this.label,
    this.foreground,
    this.background,
    this.size = 40,
    this.padding,
    this.iconSize,
    this.borderRadius,
    this.border,
    this.labelVariant = OmaBadgeLabelVariant.standard,
  }) : assert(
         icon != null || label != null,
         'OmaBadge requires either an icon or a label.',
       );

  const OmaBadge.icon({
    super.key,
    required this.icon,
    this.foreground,
    this.background,
    this.size = 40,
    this.padding,
    this.iconSize,
    this.borderRadius,
    this.border,
    this.labelVariant = OmaBadgeLabelVariant.standard,
  }) : label = null;

  const OmaBadge.label(
    this.label, {
    super.key,
    this.foreground,
    this.background,
    this.size = 40,
    this.padding,
    this.iconSize,
    this.borderRadius,
    this.border,
    this.labelVariant = OmaBadgeLabelVariant.standard,
  }) : icon = null;

  final IconData? icon;
  final String? label;

  final Color? foreground;
  final Color? background;

  /// Icon-only badge size.
  final double size;

  /// Label / icon+label badge padding.
  final EdgeInsetsGeometry? padding;

  final double? iconSize;
  final double? borderRadius;
  final BoxBorder? border;
  final OmaBadgeLabelVariant labelVariant;

  bool get isIconOnly => icon != null && label == null;

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;
    final foregroundColor = foreground ?? oma.primary;

    final backgroundColor = background ?? oma.primarySoft;

    if (isIconOnly) {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? size * 0.34),
        ),
        child: Icon(
          icon,
          size: iconSize ?? size * 0.45,
          color: foregroundColor,
        ),
      );
    }

    final labelStyle = switch (labelVariant) {
      OmaBadgeLabelVariant.standard => OmaText.label(color: foregroundColor),
      OmaBadgeLabelVariant.eyebrow => OmaText.label(
        color: foregroundColor,
        weight: FontWeight.w700,
      ).copyWith(fontSize: 9, letterSpacing: 2.3),
    };

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize ?? 14, color: foregroundColor),
            const SizedBox(width: 5),
          ],
          Text(label!, style: labelStyle),
        ],
      ),
    );
  }
}
