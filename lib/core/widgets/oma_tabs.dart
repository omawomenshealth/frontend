import 'dart:ui' show SemanticsRole;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/oma_theme.dart';

enum OmaTabsVariant { contained, line }

/// Coordinates a value-based tabs composition with a native [TabController].
///
/// [OmaTabsList] supplies the triggers and [OmaTabsContent] associates each
/// content panel with a trigger value. Selection, indicator animation, focus,
/// keyboard, pointer, and accessibility behavior remain owned by Material.
class OmaTabs<T extends Object> extends StatefulWidget {
  const OmaTabs({
    super.key,
    required this.defaultValue,
    required this.children,
    this.onValueChanged,
    this.spacing = 0,
    this.expandContent = false,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final T defaultValue;
  final List<Widget> children;
  final ValueChanged<T>? onValueChanged;
  final double spacing;
  final bool expandContent;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<OmaTabs<T>> createState() => _OmaTabsState<T>();
}

class _OmaTabsState<T extends Object> extends State<OmaTabs<T>>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  late List<T> _values;
  late T _selectedValue;

  @override
  void initState() {
    super.initState();
    _values = _triggerValues();
    _selectedValue = _validInitialValue(_values, widget.defaultValue);
    _controller = _createController(_values, _selectedValue);
  }

  @override
  void didUpdateWidget(covariant OmaTabs<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextValues = _triggerValues();
    if (!listEquals(nextValues, _values)) {
      final nextSelected = nextValues.contains(_selectedValue)
          ? _selectedValue
          : _validInitialValue(nextValues, widget.defaultValue);
      _controller
        ..removeListener(_handleSelection)
        ..dispose();
      _values = nextValues;
      _selectedValue = nextSelected;
      _controller = _createController(_values, _selectedValue);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleSelection)
      ..dispose();
    super.dispose();
  }

  List<T> _triggerValues() {
    final lists = widget.children.whereType<OmaTabsList<T>>().toList();
    assert(
      lists.length == 1,
      'OmaTabs requires exactly one direct OmaTabsList<$T> child.',
    );
    if (lists.length != 1) {
      throw FlutterError(
        'OmaTabs requires exactly one direct OmaTabsList<$T> child.',
      );
    }

    final values = lists.single.children
        .map((trigger) => trigger.value)
        .toList();
    assert(values.isNotEmpty, 'OmaTabsList requires at least one trigger.');
    assert(
      values.toSet().length == values.length,
      'Every OmaTabsTrigger value must be unique.',
    );
    return values;
  }

  T _validInitialValue(List<T> values, T requestedValue) {
    assert(
      values.contains(requestedValue),
      'defaultValue must match an OmaTabsTrigger value.',
    );
    if (!values.contains(requestedValue)) {
      throw FlutterError(
        'OmaTabs.defaultValue must match an OmaTabsTrigger value.',
      );
    }
    return requestedValue;
  }

  TabController _createController(List<T> values, T selectedValue) {
    return TabController(
      length: values.length,
      initialIndex: values.indexOf(selectedValue),
      vsync: this,
    )..addListener(_handleSelection);
  }

  void _handleSelection() {
    final selectedValue = _values[_controller.index];
    if (selectedValue == _selectedValue) return;
    setState(() => _selectedValue = selectedValue);
    widget.onValueChanged?.call(selectedValue);
  }

  @override
  Widget build(BuildContext context) {
    final lists = widget.children.whereType<OmaTabsList<T>>().toList();
    final contents = widget.children.whereType<OmaTabsContent<T>>().toList();
    assert(
      lists.length + contents.length == widget.children.length,
      'OmaTabs children must be OmaTabsList<$T> or OmaTabsContent<$T>.',
    );
    assert(
      contents.every((content) => _values.contains(content.value)),
      'Every OmaTabsContent value must match an OmaTabsTrigger value.',
    );

    Widget contentRegion = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: contents,
    );
    if (widget.expandContent) {
      contentRegion = Expanded(
        child: Stack(fit: StackFit.expand, children: contents),
      );
    }

    return _OmaTabsScope<T>(
      controller: _controller,
      selectedValue: _selectedValue,
      child: Column(
        mainAxisSize: widget.expandContent
            ? MainAxisSize.max
            : MainAxisSize.min,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: [
          lists.single,
          if (contents.isNotEmpty && widget.spacing > 0)
            SizedBox(height: widget.spacing),
          if (contents.isNotEmpty) contentRegion,
        ],
      ),
    );
  }
}

class _OmaTabsScope<T extends Object> extends InheritedWidget {
  const _OmaTabsScope({
    required this.controller,
    required this.selectedValue,
    required super.child,
  });

  final TabController controller;
  final T selectedValue;

  static _OmaTabsScope<T>? maybeOf<T extends Object>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_OmaTabsScope<T>>();
  }

  static _OmaTabsScope<T> of<T extends Object>(BuildContext context) {
    final scope = maybeOf<T>(context);
    assert(scope != null, 'Oma tabs composition requires an OmaTabs<$T>.');
    return scope!;
  }

  @override
  bool updateShouldNotify(_OmaTabsScope<T> oldWidget) {
    return controller != oldWidget.controller ||
        selectedValue != oldWidget.selectedValue;
  }
}

/// The list of native Material tab triggers in an [OmaTabs] composition.
class OmaTabsList<T extends Object> extends StatelessWidget {
  const OmaTabsList({
    super.key,
    required this.children,
    this.controller,
    this.scrollController,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.dividerColor,
    this.dividerHeight,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.onHover,
    this.onFocusChange,
    this.physics,
    this.splashFactory,
    this.splashBorderRadius,
    this.tabAlignment,
    this.textScaler,
    this.indicatorAnimation,
    this.margin,
    this.contentPadding,
    this.decoration,
    this.variant = OmaTabsVariant.contained,
  }) : _secondary = false;

  const OmaTabsList.secondary({
    super.key,
    required this.children,
    this.controller,
    this.scrollController,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.dividerColor,
    this.dividerHeight,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.onHover,
    this.onFocusChange,
    this.physics,
    this.splashFactory,
    this.splashBorderRadius,
    this.tabAlignment,
    this.textScaler,
    this.indicatorAnimation,
    this.margin,
    this.contentPadding,
    this.decoration,
    this.variant = OmaTabsVariant.contained,
  }) : _secondary = true;

  final List<OmaTabsTrigger<T>> children;
  final TabController? controller;
  final TabBarScrollController? scrollController;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Color? indicatorColor;
  final bool automaticIndicatorColorAdjustment;
  final double indicatorWeight;
  final EdgeInsetsGeometry indicatorPadding;
  final Decoration? indicator;
  final TabBarIndicatorSize? indicatorSize;
  final Color? dividerColor;
  final double? dividerHeight;
  final Color? labelColor;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final Color? unselectedLabelColor;
  final TextStyle? unselectedLabelStyle;
  final DragStartBehavior dragStartBehavior;
  final WidgetStateProperty<Color?>? overlayColor;
  final MouseCursor? mouseCursor;
  final bool? enableFeedback;
  final ValueChanged<int>? onTap;
  final TabValueChanged<bool>? onHover;
  final TabValueChanged<bool>? onFocusChange;
  final ScrollPhysics? physics;
  final InteractiveInkFeatureFactory? splashFactory;
  final BorderRadius? splashBorderRadius;
  final TabAlignment? tabAlignment;
  final TextScaler? textScaler;
  final TabIndicatorAnimation? indicatorAnimation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final Decoration? decoration;
  final OmaTabsVariant variant;

  final bool _secondary;

  @override
  Widget build(BuildContext context) {
    final scope = _OmaTabsScope.maybeOf<T>(context);
    final effectiveController = controller ?? scope?.controller;
    final contained = variant == OmaTabsVariant.contained;
    final effectiveIndicator =
        indicator ??
        (contained
            ? BoxDecoration(
                color: context.omaTheme.surface,
                borderRadius: BorderRadius.circular(OmaRadius.md),
                boxShadow: context.omaTheme.softShadow,
              )
            : null);
    final effectiveIndicatorSize =
        indicatorSize ?? (contained ? TabBarIndicatorSize.tab : null);
    final effectiveDividerHeight =
        dividerHeight ?? (contained ? OmaSpacing.none : null);
    final effectiveLabelPadding =
        labelPadding ??
        (contained
            ? const EdgeInsets.symmetric(horizontal: OmaSpacing.xs)
            : null);
    final effectiveSplashBorderRadius =
        splashBorderRadius ??
        (contained ? BorderRadius.circular(OmaRadius.md) : null);
    final effectiveContentPadding =
        contentPadding ??
        (contained ? const EdgeInsets.all(OmaSpacing.xs) : null);
    final effectiveDecoration =
        decoration ??
        (contained
            ? BoxDecoration(
                color: context.omaTheme.backgroundAlt,
                borderRadius: BorderRadius.circular(OmaRadius.lg),
                border: Border.all(color: context.omaTheme.border),
              )
            : null);
    final tabBar = _secondary
        ? TabBar.secondary(
            tabs: children,
            controller: effectiveController,
            scrollController: scrollController,
            isScrollable: isScrollable,
            padding: padding,
            indicatorColor: indicatorColor,
            automaticIndicatorColorAdjustment:
                automaticIndicatorColorAdjustment,
            indicatorWeight: indicatorWeight,
            indicatorPadding: indicatorPadding,
            indicator: effectiveIndicator,
            indicatorSize: effectiveIndicatorSize,
            dividerColor: dividerColor,
            dividerHeight: effectiveDividerHeight,
            labelColor: labelColor,
            labelStyle: labelStyle,
            labelPadding: effectiveLabelPadding,
            unselectedLabelColor: unselectedLabelColor,
            unselectedLabelStyle: unselectedLabelStyle,
            dragStartBehavior: dragStartBehavior,
            overlayColor: overlayColor,
            mouseCursor: mouseCursor,
            enableFeedback: enableFeedback,
            onTap: onTap,
            onHover: onHover,
            onFocusChange: onFocusChange,
            physics: physics,
            splashFactory: splashFactory,
            splashBorderRadius: effectiveSplashBorderRadius,
            tabAlignment: tabAlignment,
            textScaler: textScaler,
            indicatorAnimation: indicatorAnimation,
          )
        : TabBar(
            tabs: children,
            controller: effectiveController,
            scrollController: scrollController,
            isScrollable: isScrollable,
            padding: padding,
            indicatorColor: indicatorColor,
            automaticIndicatorColorAdjustment:
                automaticIndicatorColorAdjustment,
            indicatorWeight: indicatorWeight,
            indicatorPadding: indicatorPadding,
            indicator: effectiveIndicator,
            indicatorSize: effectiveIndicatorSize,
            dividerColor: dividerColor,
            dividerHeight: effectiveDividerHeight,
            labelColor: labelColor,
            labelStyle: labelStyle,
            labelPadding: effectiveLabelPadding,
            unselectedLabelColor: unselectedLabelColor,
            unselectedLabelStyle: unselectedLabelStyle,
            dragStartBehavior: dragStartBehavior,
            overlayColor: overlayColor,
            mouseCursor: mouseCursor,
            enableFeedback: enableFeedback,
            onTap: onTap,
            onHover: onHover,
            onFocusChange: onFocusChange,
            physics: physics,
            splashFactory: splashFactory,
            splashBorderRadius: effectiveSplashBorderRadius,
            tabAlignment: tabAlignment,
            textScaler: textScaler,
            indicatorAnimation: indicatorAnimation,
          );

    if (margin == null &&
        effectiveContentPadding == null &&
        effectiveDecoration == null) {
      return tabBar;
    }
    return Container(
      margin: margin,
      padding: effectiveContentPadding,
      decoration: effectiveDecoration,
      child: tabBar,
    );
  }
}

/// A value-bearing native Material [Tab].
class OmaTabsTrigger<T extends Object> extends Tab {
  const OmaTabsTrigger({
    super.key,
    required this.value,
    super.text,
    super.icon,
    super.iconMargin,
    super.height,
    super.child,
  });

  final T value;
}

/// A content panel associated with an [OmaTabsTrigger.value].
class OmaTabsContent<T extends Object> extends StatelessWidget {
  const OmaTabsContent({super.key, required this.value, required this.child});

  final T value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selected = _OmaTabsScope.of<T>(context).selectedValue == value;
    return Offstage(
      offstage: !selected,
      child: TickerMode(
        enabled: selected,
        child: Semantics(role: SemanticsRole.tabPanel, child: child),
      ),
    );
  }
}
