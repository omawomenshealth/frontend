import 'package:flutter/material.dart';

/// An Oma-themed checkbox tile backed by Material's [CheckboxListTile].
///
/// The caller controls [value] through [onChanged], including native tristate
/// behavior. Styling comes from [ListTileThemeData] and [CheckboxThemeData],
/// and explicit Material-style properties override those defaults.
class OmaCheckboxListTile extends StatelessWidget {
  /// Uses Material's native [CheckboxListTile.new] implementation.
  const OmaCheckboxListTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.statesController,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.enabled,
    this.tileColor,
    this.title,
    this.subtitle,
    this.isThreeLine,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity,
    this.contentPadding,
    this.tristate = false,
    this.checkboxShape,
    this.selectedTileColor,
    this.onFocusChange,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
    this.minTileHeight,
    this.checkboxSemanticLabel,
    this.checkboxScaleFactor = 1.0,
    this.titleAlignment,
  }) : _adaptive = false,
       assert(tristate || value != null),
       assert(isThreeLine != true || subtitle != null);

  /// Uses Material's native [CheckboxListTile.adaptive] implementation.
  ///
  /// Flutter chooses the platform-specific checkbox; Oma performs no platform
  /// detection of its own.
  const OmaCheckboxListTile.adaptive({
    super.key,
    required this.value,
    required this.onChanged,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.statesController,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.enabled,
    this.tileColor,
    this.title,
    this.subtitle,
    this.isThreeLine,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity,
    this.contentPadding,
    this.tristate = false,
    this.checkboxShape,
    this.selectedTileColor,
    this.onFocusChange,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
    this.minTileHeight,
    this.checkboxSemanticLabel,
    this.checkboxScaleFactor = 1.0,
    this.titleAlignment,
  }) : _adaptive = true,
       assert(tristate || value != null),
       assert(isThreeLine != true || subtitle != null);

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final WidgetStatesController? statesController;
  final bool autofocus;
  final ShapeBorder? shape;
  final BorderSide? side;
  final bool isError;
  final bool? enabled;
  final Color? tileColor;
  final Widget? title;
  final Widget? subtitle;
  final bool? isThreeLine;
  final bool? dense;
  final Widget? secondary;
  final bool selected;
  final ListTileControlAffinity? controlAffinity;
  final EdgeInsetsGeometry? contentPadding;
  final bool tristate;
  final OutlinedBorder? checkboxShape;
  final Color? selectedTileColor;
  final ValueChanged<bool>? onFocusChange;
  final bool? enableFeedback;
  final double? horizontalTitleGap;
  final double? minVerticalPadding;
  final double? minLeadingWidth;
  final double? minTileHeight;
  final String? checkboxSemanticLabel;
  final double checkboxScaleFactor;
  final ListTileTitleAlignment? titleAlignment;
  final bool _adaptive;

  @override
  Widget build(BuildContext context) {
    if (_adaptive) {
      return CheckboxListTile.adaptive(
        value: value,
        onChanged: onChanged,
        mouseCursor: mouseCursor,
        activeColor: activeColor,
        fillColor: fillColor,
        checkColor: checkColor,
        hoverColor: hoverColor,
        overlayColor: overlayColor,
        splashRadius: splashRadius,
        materialTapTargetSize: materialTapTargetSize,
        visualDensity: visualDensity,
        focusNode: focusNode,
        statesController: statesController,
        autofocus: autofocus,
        shape: shape,
        side: side,
        isError: isError,
        enabled: enabled,
        tileColor: tileColor,
        title: title,
        subtitle: subtitle,
        isThreeLine: isThreeLine,
        dense: dense,
        secondary: secondary,
        selected: selected,
        controlAffinity: controlAffinity,
        contentPadding: contentPadding,
        tristate: tristate,
        checkboxShape: checkboxShape,
        selectedTileColor: selectedTileColor,
        onFocusChange: onFocusChange,
        enableFeedback: enableFeedback,
        horizontalTitleGap: horizontalTitleGap,
        minVerticalPadding: minVerticalPadding,
        minLeadingWidth: minLeadingWidth,
        minTileHeight: minTileHeight,
        checkboxSemanticLabel: checkboxSemanticLabel,
        checkboxScaleFactor: checkboxScaleFactor,
        titleAlignment: titleAlignment,
      );
    }

    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      mouseCursor: mouseCursor,
      activeColor: activeColor,
      fillColor: fillColor,
      checkColor: checkColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      focusNode: focusNode,
      statesController: statesController,
      autofocus: autofocus,
      shape: shape,
      side: side,
      isError: isError,
      enabled: enabled,
      tileColor: tileColor,
      title: title,
      subtitle: subtitle,
      isThreeLine: isThreeLine,
      dense: dense,
      secondary: secondary,
      selected: selected,
      controlAffinity: controlAffinity,
      contentPadding: contentPadding,
      tristate: tristate,
      checkboxShape: checkboxShape,
      selectedTileColor: selectedTileColor,
      onFocusChange: onFocusChange,
      enableFeedback: enableFeedback,
      horizontalTitleGap: horizontalTitleGap,
      minVerticalPadding: minVerticalPadding,
      minLeadingWidth: minLeadingWidth,
      minTileHeight: minTileHeight,
      checkboxSemanticLabel: checkboxSemanticLabel,
      checkboxScaleFactor: checkboxScaleFactor,
      titleAlignment: titleAlignment,
    );
  }
}
