import 'package:flutter/material.dart';

/// An Oma-themed checkbox backed by Material's native [Checkbox].
///
/// Selection state remains controlled by the caller through [value] and
/// [onChanged]. Native tristate behavior is available through [tristate], while
/// default styling comes from the app's [CheckboxThemeData]. Explicit Material
/// style properties override those defaults.
class OmaCheckbox extends StatelessWidget {
  /// Creates a checkbox using Material's native [Checkbox.new] behavior.
  const OmaCheckbox({
    super.key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.semanticLabel,
  }) : _adaptive = false,
       assert(tristate || value != null);

  /// Creates a checkbox using Material's native [Checkbox.adaptive] behavior.
  ///
  /// Flutter selects the platform-appropriate implementation; Oma does not
  /// perform its own platform detection.
  const OmaCheckbox.adaptive({
    super.key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.semanticLabel,
  }) : _adaptive = true,
       assert(tristate || value != null);

  final bool? value;
  final bool tristate;
  final ValueChanged<bool?>? onChanged;
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final OutlinedBorder? shape;
  final BorderSide? side;
  final bool isError;
  final String? semanticLabel;

  final bool _adaptive;

  @override
  Widget build(BuildContext context) {
    if (_adaptive) {
      return Checkbox.adaptive(
        value: value,
        tristate: tristate,
        onChanged: onChanged,
        mouseCursor: mouseCursor,
        activeColor: activeColor,
        fillColor: fillColor,
        checkColor: checkColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        overlayColor: overlayColor,
        splashRadius: splashRadius,
        materialTapTargetSize: materialTapTargetSize,
        visualDensity: visualDensity,
        focusNode: focusNode,
        autofocus: autofocus,
        shape: shape,
        side: side,
        isError: isError,
        semanticLabel: semanticLabel,
      );
    }

    return Checkbox(
      value: value,
      tristate: tristate,
      onChanged: onChanged,
      mouseCursor: mouseCursor,
      activeColor: activeColor,
      fillColor: fillColor,
      checkColor: checkColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      focusNode: focusNode,
      autofocus: autofocus,
      shape: shape,
      side: side,
      isError: isError,
      semanticLabel: semanticLabel,
    );
  }
}
