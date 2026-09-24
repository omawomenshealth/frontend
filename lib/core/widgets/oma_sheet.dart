import 'package:flutter/material.dart';

import '../theme/oma_theme.dart';

/// Shows a draggable, theme-aware modal sheet.
///
/// The [scrollController] passed to [builder] should be attached to the
/// sheet's primary scrollable so dragging and scrolling work together.
Future<T?> showOmaSheet<T>({
  required BuildContext context,
  required Widget Function(
    BuildContext context,
    ScrollController scrollController,
  )
  builder,
  double initialChildSize = 0.96,
  double minChildSize = 0.60,
  double maxChildSize = 0.96,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  assert(minChildSize >= 0 && minChildSize <= 1);
  assert(initialChildSize >= minChildSize);
  assert(initialChildSize <= maxChildSize);
  assert(maxChildSize <= 1);

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (context, scrollController) {
          return AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: builder(context, scrollController),
          );
        },
      );
    },
  );
}

/// The shared visual structure for an Oma modal sheet.
///
/// [body] occupies the remaining height between the fixed header and [footer].
/// Make [body] scrollable when its content can exceed the available space.
class OmaSheet extends StatelessWidget {
  const OmaSheet({
    super.key,
    required this.body,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.footer,
    this.showHandle = true,
    this.showCloseButton = true,
  });

  final Widget body;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? footer;
  final bool showHandle;
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;

    return DecoratedBox(
      key: const ValueKey('oma_sheet_surface'),
      decoration: BoxDecoration(
        color: oma.surface,
        border: Border.all(color: oma.border),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(OmaRadius.xl),
        ),
        boxShadow: oma.topSheetShadow,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(OmaRadius.xl),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              if (showHandle) const _SheetHandle(),
              if (_hasHeader) _buildHeader(context),
              Expanded(child: body),
              if (footer != null) _SheetFooter(child: footer!),
            ],
          ),
        ),
      ),
    );
  }

  bool get _hasHeader =>
      title != null ||
      subtitle != null ||
      leading != null ||
      trailing != null ||
      showCloseButton;

  Widget _buildHeader(BuildContext context) {
    final oma = context.omaTheme;

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
                  if (title != null)
                    Text(
                      title!,
                      style: OmaText.display(
                        OmaTypeScale.title,
                        color: oma.foreground,
                      ),
                    ),
                  if (title != null && subtitle != null)
                    const SizedBox(height: OmaSpacing.xs),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: OmaText.body(OmaTypeScale.body, color: oma.muted),
                    ),
                ],
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: OmaSpacing.sm),
            trailing!,
          ],
          if (showCloseButton)
            SizedBox.square(
              dimension: OmaSpacing.massive,
              child: IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close, color: oma.foreground),
              ),
            ),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;

    return Padding(
      padding: const EdgeInsets.only(top: OmaSpacing.md, bottom: OmaSpacing.xs),
      child: Container(
        key: const ValueKey('oma_sheet_handle'),
        width: OmaSpacing.huge,
        height: OmaSpacing.xs,
        decoration: BoxDecoration(
          color: oma.border,
          borderRadius: BorderRadius.circular(OmaRadius.full),
        ),
      ),
    );
  }
}

class _SheetFooter extends StatelessWidget {
  const _SheetFooter({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;

    return DecoratedBox(
      key: const ValueKey('oma_sheet_footer'),
      decoration: BoxDecoration(
        color: oma.surface,
        border: Border(top: BorderSide(color: oma.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          OmaSpacing.xl,
          OmaSpacing.lg,
          OmaSpacing.xl,
          OmaSpacing.xl,
        ),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
