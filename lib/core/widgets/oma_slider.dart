import 'package:flutter/material.dart';

/// An Oma-themed value selector backed by Material's native [Slider].
///
/// The caller owns the selected [value] and updates it through [onChanged].
/// Both continuous and [divisions]-based discrete selection are supported,
/// along with native secondary progress through [secondaryTrackValue]. Default
/// styling comes from the app's [SliderThemeData]; explicit Material-style
/// color and interaction properties override those defaults.
class OmaSlider extends StatelessWidget {
  /// Creates a slider using Material's native [Slider.new] behavior.
  const OmaSlider({
    super.key,
    required this.value,
    this.secondaryTrackValue,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.overlayColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
    this.allowedInteraction,
    this.padding,
    this.showValueIndicator,
  }) : _adaptive = false,
       assert(min <= max),
       assert(value >= min && value <= max),
       assert(
         secondaryTrackValue == null ||
             (secondaryTrackValue >= min && secondaryTrackValue <= max),
       ),
       assert(divisions == null || divisions > 0);

  /// Creates a slider using Material's native [Slider.adaptive] behavior.
  ///
  /// Flutter selects the platform-appropriate implementation; Oma does not
  /// perform its own platform detection.
  const OmaSlider.adaptive({
    super.key,
    required this.value,
    this.secondaryTrackValue,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.overlayColor,
    this.mouseCursor,
    this.semanticFormatterCallback,
    this.focusNode,
    this.autofocus = false,
    this.allowedInteraction,
    this.showValueIndicator,
  }) : _adaptive = true,
       padding = null,
       assert(min <= max),
       assert(value >= min && value <= max),
       assert(
         secondaryTrackValue == null ||
             (secondaryTrackValue >= min && secondaryTrackValue <= max),
       ),
       assert(divisions == null || divisions > 0);

  final double value;
  final double? secondaryTrackValue;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? secondaryActiveColor;
  final Color? thumbColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final MouseCursor? mouseCursor;
  final SemanticFormatterCallback? semanticFormatterCallback;
  final FocusNode? focusNode;
  final bool autofocus;
  final SliderInteraction? allowedInteraction;
  final EdgeInsetsGeometry? padding;
  final ShowValueIndicator? showValueIndicator;

  final bool _adaptive;

  @override
  Widget build(BuildContext context) {
    if (_adaptive) {
      return Slider.adaptive(
        value: value,
        secondaryTrackValue: secondaryTrackValue,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        secondaryActiveColor: secondaryActiveColor,
        thumbColor: thumbColor,
        overlayColor: overlayColor,
        mouseCursor: mouseCursor,
        semanticFormatterCallback: semanticFormatterCallback,
        focusNode: focusNode,
        autofocus: autofocus,
        allowedInteraction: allowedInteraction,
        showValueIndicator: showValueIndicator,
      );
    }

    return Slider(
      value: value,
      secondaryTrackValue: secondaryTrackValue,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      divisions: divisions,
      label: label,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      secondaryActiveColor: secondaryActiveColor,
      thumbColor: thumbColor,
      overlayColor: overlayColor,
      mouseCursor: mouseCursor,
      semanticFormatterCallback: semanticFormatterCallback,
      focusNode: focusNode,
      autofocus: autofocus,
      allowedInteraction: allowedInteraction,
      padding: padding,
      showValueIndicator: showValueIndicator,
    );
  }
}
