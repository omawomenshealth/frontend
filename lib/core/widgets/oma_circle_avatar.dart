import 'package:flutter/material.dart';

/// A native [CircleAvatar] styled by Oma's Material [ColorScheme].
///
/// When colors are not provided, Material 3 resolves them from
/// [ColorScheme.primaryContainer] and [ColorScheme.onPrimaryContainer], which
/// are mapped to Oma's semantic theme colors by `AppTheme`.
class OmaCircleAvatar extends StatelessWidget {
  const OmaCircleAvatar({
    super.key,
    this.child,
    this.backgroundColor,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.foregroundColor,
    this.radius,
    this.minRadius,
    this.maxRadius,
  }) : assert(radius == null || (minRadius == null && maxRadius == null)),
       assert(backgroundImage != null || onBackgroundImageError == null),
       assert(foregroundImage != null || onForegroundImageError == null);

  final Widget? child;
  final Color? backgroundColor;
  final ImageProvider? backgroundImage;
  final ImageProvider? foregroundImage;
  final ImageErrorListener? onBackgroundImageError;
  final ImageErrorListener? onForegroundImageError;
  final Color? foregroundColor;
  final double? radius;
  final double? minRadius;
  final double? maxRadius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      backgroundImage: backgroundImage,
      foregroundImage: foregroundImage,
      onBackgroundImageError: onBackgroundImageError,
      onForegroundImageError: onForegroundImageError,
      foregroundColor: foregroundColor,
      radius: radius,
      minRadius: minRadius,
      maxRadius: maxRadius,
      child: child,
    );
  }
}
