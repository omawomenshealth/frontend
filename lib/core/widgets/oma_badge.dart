import 'package:flutter/material.dart';

/// A Material [Badge] with Oma defaults supplied by [BadgeThemeData].
///
/// This wrapper preserves Material's content model: a null [label] produces
/// the native small badge, while a non-null [label] produces the native large
/// stadium badge. Explicit style values take precedence over the app theme.
class OmaBadge extends StatelessWidget {
  /// Creates a badge with the same inputs and behavior as [Badge.new].
  const OmaBadge({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.smallSize,
    this.largeSize,
    this.textStyle,
    this.padding,
    this.alignment,
    this.offset,
    this.label,
    this.isLabelVisible = true,
    this.child,
  }) : _count = null,
       _maxCount = null;

  /// Creates a numeric badge using Material's native [Badge.count] behavior.
  const OmaBadge.count({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.smallSize,
    this.largeSize,
    this.textStyle,
    this.padding,
    this.alignment,
    this.offset,
    required int count,
    int maxCount = 999,
    this.isLabelVisible = true,
    this.child,
  }) : assert(count >= 0, 'count must be non-negative'),
       assert(maxCount > 0, 'maxCount must be positive'),
       label = null,
       _count = count,
       _maxCount = maxCount;

  final Color? backgroundColor;
  final Color? textColor;
  final double? smallSize;
  final double? largeSize;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Offset? offset;
  final Widget? label;
  final bool isLabelVisible;
  final Widget? child;

  final int? _count;
  final int? _maxCount;

  @override
  Widget build(BuildContext context) {
    final count = _count;
    if (count != null) {
      return Badge.count(
        backgroundColor: backgroundColor,
        textColor: textColor,
        smallSize: smallSize,
        largeSize: largeSize,
        textStyle: textStyle,
        padding: padding,
        alignment: alignment,
        offset: offset,
        count: count,
        maxCount: _maxCount!,
        isLabelVisible: isLabelVisible,
        child: child,
      );
    }

    return Badge(
      backgroundColor: backgroundColor,
      textColor: textColor,
      smallSize: smallSize,
      largeSize: largeSize,
      textStyle: textStyle,
      padding: padding,
      alignment: alignment,
      offset: offset,
      label: label,
      isLabelVisible: isLabelVisible,
      child: child,
    );
  }
}
