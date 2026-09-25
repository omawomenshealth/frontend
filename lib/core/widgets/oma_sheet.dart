import 'package:flutter/material.dart';

import '../theme/oma_theme.dart';

/// Sizing behavior for a draggable Oma sheet.
@immutable
class OmaSheetDragConfiguration {
  const OmaSheetDragConfiguration({
    this.initialChildSize = 0.96,
    this.minChildSize = 0.60,
    this.maxChildSize = 0.96,
  }) : assert(minChildSize > 0 && minChildSize <= 1),
       assert(maxChildSize > 0 && maxChildSize <= 1),
       assert(initialChildSize >= minChildSize),
       assert(initialChildSize <= maxChildSize);

  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
}

/// Builder used by [showOmaSheet].
///
/// [scrollController] is non-null only when [OmaSheetDragConfiguration]
/// is provided. Attach it to the sheet's primary vertical scrollable.
typedef OmaSheetBuilder =
    Widget Function(BuildContext context, ScrollController? scrollController);

/// Opens an Oma modal sheet using Flutter's native Material bottom-sheet
/// presentation.
///
/// By default this behaves like a normal modal bottom sheet.
///
/// For long, scrollable content, provide [dragConfiguration]. In that case,
/// [builder] receives the [ScrollController] created by
/// [DraggableScrollableSheet]. Attach that controller to the primary
/// scrollable:
///
/// ```dart
/// showOmaSheet(
///   context: context,
///   dragConfiguration: const OmaSheetDragConfiguration(),
///   builder: (context, scrollController) {
///     return OmaSheet(
///       child: ListView(
///         controller: scrollController,
///         children: [...],
///       ),
///     );
///   },
/// );
/// ```
///
/// Surface styling is intentionally left to Flutter's
/// [BottomSheetThemeData] configured by the Oma theme.
Future<T?> showOmaSheet<T>({
  required BuildContext context,
  required OmaSheetBuilder builder,
  bool isDismissible = true,
  bool enableDrag = true,
  bool isScrollControlled = true,
  bool useSafeArea = false,
  bool? showDragHandle,
  OmaSheetDragConfiguration? dragConfiguration,
}) {
  assert(dragConfiguration == null || isScrollControlled);

  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    showDragHandle: showDragHandle ?? enableDrag,
    builder: (sheetContext) {
      Widget buildSheet(
        BuildContext context, [
        ScrollController? scrollController,
      ]) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: builder(context, scrollController),
        );
      }

      final drag = dragConfiguration;

      if (drag == null) {
        return buildSheet(sheetContext);
      }

      return DraggableScrollableSheet(
        initialChildSize: drag.initialChildSize,
        minChildSize: drag.minChildSize,
        maxChildSize: drag.maxChildSize,
        expand: false,
        builder: (context, scrollController) {
          return buildSheet(context, scrollController);
        },
      );
    },
  );
}

/// Root layout primitive for Oma sheet content.
///
/// Material sheet presentation and surface styling are handled by
/// [showModalBottomSheet] and [BottomSheetThemeData].
///
/// This widget owns the bottom safe area for the sheet content.
class OmaSheet extends StatelessWidget {
  const OmaSheet({
    super.key,
    required this.child,
    this.maintainBottomViewPadding = false,
  });

  final Widget child;

  /// Whether the bottom view padding should remain when the keyboard appears.
  final bool maintainBottomViewPadding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      maintainBottomViewPadding: maintainBottomViewPadding,
      child: child,
    );
  }
}

/// Standard header layout for an Oma sheet.
///
/// [title] and [description] accept widgets so callers can use the standard
/// [OmaSheetTitle] and [OmaSheetDescription] primitives or provide custom
/// content when needed.
class OmaSheetHeader extends StatelessWidget {
  const OmaSheetHeader({
    super.key,
    this.title,
    this.description,
    this.leading,
    this.trailing,
    this.showCloseButton = true,
  });

  final Widget? title;
  final Widget? description;
  final Widget? leading;
  final Widget? trailing;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        OmaSpacing.xl,
        OmaSpacing.sm,
        OmaSpacing.sm,
        OmaSpacing.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: OmaSpacing.xs),
              child: leading!,
            ),
            const SizedBox(width: OmaSpacing.md),
          ],

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: OmaSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ?title,

                  if (title != null && description != null)
                    const SizedBox(height: OmaSpacing.xs),

                  ?description,
                ],
              ),
            ),
          ),

          if (trailing != null) ...[
            const SizedBox(width: OmaSpacing.sm),
            trailing!,
          ],

          if (showCloseButton) const OmaSheetClose(),
        ],
      ),
    );
  }
}

/// Standard title typography for an Oma sheet.
class OmaSheetTitle extends StatelessWidget {
  const OmaSheetTitle(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: OmaText.display(
        OmaTypeScale.title,
        color: context.omaTheme.foreground,
      ),
    );
  }
}

/// Standard supporting typography for an Oma sheet.
class OmaSheetDescription extends StatelessWidget {
  const OmaSheetDescription(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: OmaText.body(OmaTypeScale.body, color: context.omaTheme.muted),
    );
  }
}

/// Localized close action for an Oma sheet.
///
/// Uses Flutter's native [IconButton] interaction and accessibility behavior.
class OmaSheetClose<T extends Object?> extends StatelessWidget {
  const OmaSheetClose({super.key, this.result});

  final T? result;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: OmaSpacing.massive,
      child: IconButton(
        tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        onPressed: () {
          Navigator.of(context).maybePop<T>(result);
        },
        icon: Icon(Icons.close, color: context.omaTheme.foreground),
      ),
    );
  }
}

/// Padding-only content primitive.
///
/// This widget intentionally owns no scrolling behavior. The feature decides
/// whether its content should use a Column, ListView, CustomScrollView, etc.
class OmaSheetContent extends StatelessWidget {
  const OmaSheetContent({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(
      OmaSpacing.xl,
      OmaSpacing.sm,
      OmaSpacing.xl,
      OmaSpacing.xl,
    ),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

/// Fixed action area for an Oma sheet.
///
/// This widget provides only layout and presentation. Button/action behavior
/// belongs to the child passed by the feature.
class OmaSheetFooter extends StatelessWidget {
  const OmaSheetFooter({
    super.key,
    required this.child,
    this.showDivider = true,
    this.padding = const EdgeInsets.fromLTRB(
      OmaSpacing.xl,
      OmaSpacing.lg,
      OmaSpacing.xl,
      OmaSpacing.xl,
    ),
  });

  final Widget child;
  final bool showDivider;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;

    return DecoratedBox(
      key: const ValueKey('oma_sheet_footer'),
      decoration: BoxDecoration(
        color: oma.surface,
        border: showDivider ? Border(top: BorderSide(color: oma.border)) : null,
      ),
      child: Padding(
        padding: padding,
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
