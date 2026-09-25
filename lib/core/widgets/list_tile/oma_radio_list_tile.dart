import 'package:flutter/material.dart';

/// An Oma-themed radio tile backed by Material's native [RadioListTile].
///
/// Selection is managed by the nearest [RadioGroup], matching Flutter's
/// current radio-group API. Styling comes from [ListTileThemeData] and
/// [RadioThemeData], while explicit Material-style properties remain
/// available as overrides. Native interaction and accessibility are preserved.
class OmaRadioListTile<T> extends StatelessWidget {
  /// Uses Material's native [RadioListTile.new] implementation.
  const OmaRadioListTile({
    super.key,
    required this.value,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.title,
    this.subtitle,
    this.isThreeLine,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity,
    this.autofocus = false,
    this.contentPadding,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.statesController,
    this.onFocusChange,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
    this.minTileHeight,
    this.radioScaleFactor = 1.0,
    this.titleAlignment,
    this.enabled,
    this.radioBackgroundColor,
    this.radioSide,
    this.radioInnerRadius,
  }) : _adaptive = false,
       useCupertinoCheckmarkStyle = false,
       assert(isThreeLine != true || subtitle != null);

  /// Uses Material's native [RadioListTile.adaptive] implementation.
  ///
  /// Flutter chooses the platform-specific radio; Oma performs no platform
  /// detection of its own.
  const OmaRadioListTile.adaptive({
    super.key,
    required this.value,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.title,
    this.subtitle,
    this.isThreeLine,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity,
    this.autofocus = false,
    this.contentPadding,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.statesController,
    this.onFocusChange,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
    this.minTileHeight,
    this.radioScaleFactor = 1.0,
    this.enabled,
    this.useCupertinoCheckmarkStyle = false,
    this.titleAlignment,
    this.radioBackgroundColor,
    this.radioSide,
    this.radioInnerRadius,
  }) : _adaptive = true,
       assert(isThreeLine != true || subtitle != null);

  final T value;
  final MouseCursor? mouseCursor;
  final bool toggleable;
  final Color? activeColor;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final Widget? title;
  final Widget? subtitle;
  final bool? isThreeLine;
  final bool? dense;
  final Widget? secondary;
  final bool selected;
  final ListTileControlAffinity? controlAffinity;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final ShapeBorder? shape;
  final Color? tileColor;
  final Color? selectedTileColor;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final WidgetStatesController? statesController;
  final ValueChanged<bool>? onFocusChange;
  final bool? enableFeedback;
  final double? horizontalTitleGap;
  final double? minVerticalPadding;
  final double? minLeadingWidth;
  final double? minTileHeight;
  final double radioScaleFactor;
  final ListTileTitleAlignment? titleAlignment;
  final bool? enabled;
  final bool useCupertinoCheckmarkStyle;
  final WidgetStateProperty<Color?>? radioBackgroundColor;
  final BorderSide? radioSide;
  final WidgetStateProperty<double?>? radioInnerRadius;
  final bool _adaptive;

  @override
  Widget build(BuildContext context) {
    if (_adaptive) {
      return RadioListTile<T>.adaptive(
        value: value,
        mouseCursor: mouseCursor,
        toggleable: toggleable,
        activeColor: activeColor,
        fillColor: fillColor,
        hoverColor: hoverColor,
        overlayColor: overlayColor,
        splashRadius: splashRadius,
        materialTapTargetSize: materialTapTargetSize,
        title: title,
        subtitle: subtitle,
        isThreeLine: isThreeLine,
        dense: dense,
        secondary: secondary,
        selected: selected,
        controlAffinity: controlAffinity,
        autofocus: autofocus,
        contentPadding: contentPadding,
        shape: shape,
        tileColor: tileColor,
        selectedTileColor: selectedTileColor,
        visualDensity: visualDensity,
        focusNode: focusNode,
        statesController: statesController,
        onFocusChange: onFocusChange,
        enableFeedback: enableFeedback,
        horizontalTitleGap: horizontalTitleGap,
        minVerticalPadding: minVerticalPadding,
        minLeadingWidth: minLeadingWidth,
        minTileHeight: minTileHeight,
        radioScaleFactor: radioScaleFactor,
        enabled: enabled,
        useCupertinoCheckmarkStyle: useCupertinoCheckmarkStyle,
        titleAlignment: titleAlignment,
        radioBackgroundColor: radioBackgroundColor,
        radioSide: radioSide,
        radioInnerRadius: radioInnerRadius,
      );
    }

    return RadioListTile<T>(
      value: value,
      mouseCursor: mouseCursor,
      toggleable: toggleable,
      activeColor: activeColor,
      fillColor: fillColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      materialTapTargetSize: materialTapTargetSize,
      title: title,
      subtitle: subtitle,
      isThreeLine: isThreeLine,
      dense: dense,
      secondary: secondary,
      selected: selected,
      controlAffinity: controlAffinity,
      autofocus: autofocus,
      contentPadding: contentPadding,
      shape: shape,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      visualDensity: visualDensity,
      focusNode: focusNode,
      statesController: statesController,
      onFocusChange: onFocusChange,
      enableFeedback: enableFeedback,
      horizontalTitleGap: horizontalTitleGap,
      minVerticalPadding: minVerticalPadding,
      minLeadingWidth: minLeadingWidth,
      minTileHeight: minTileHeight,
      radioScaleFactor: radioScaleFactor,
      titleAlignment: titleAlignment,
      enabled: enabled,
      radioBackgroundColor: radioBackgroundColor,
      radioSide: radioSide,
      radioInnerRadius: radioInnerRadius,
    );
  }
}
