import 'package:flutter/material.dart';

import '../theme/oma_theme.dart';
import 'oma_button.dart';
import 'oma_divider.dart';
import 'oma_icon_button.dart';

/// Material 3 recommended maximum width for a standard dialog.
const double _omaDialogMaxWidth = 560;

/// Opens an Oma dialog using Flutter's native Material dialog route.
Future<T?> showOmaDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  bool useSafeArea = true,
  bool useRootNavigator = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    builder: builder,
  );
}

/// Shows the common two-action confirmation composition.
///
/// Labels must be localized by the caller. When [cancelLabel] is omitted,
/// Flutter's localized Material cancel label is used.
Future<bool?> showOmaConfirmationDialog({
  required BuildContext context,
  required String title,
  required String description,
  required String confirmLabel,
  String? cancelLabel,
  bool barrierDismissible = false,
  bool useRootNavigator = true,
}) {
  return showOmaDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder: (dialogContext) {
      final effectiveCancelLabel =
          cancelLabel ??
          MaterialLocalizations.of(dialogContext).cancelButtonLabel;

      return OmaDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OmaDialogHeader(
              title: OmaDialogTitle(title),
              description: OmaDialogDescription(description),
              showCloseButton: false,
            ),
            OmaDialogFooter(
              child: Row(
                children: [
                  Expanded(
                    child: OmaButton(
                      label: effectiveCancelLabel,
                      variant: OmaButtonVariant.secondary,
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                    ),
                  ),
                  const SizedBox(width: OmaSpacing.md),
                  Expanded(
                    child: OmaButton(
                      label: confirmLabel,
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Root surface primitive for an Oma dialog.
///
/// Surface appearance comes from [DialogThemeData]. The default constraint is
/// the Material 3 recommended maximum dialog width, while smaller screens are
/// still governed by Flutter's native dialog insets.
class OmaDialog extends StatelessWidget {
  const OmaDialog({
    super.key,
    required this.child,
    this.constraints = const BoxConstraints(maxWidth: _omaDialogMaxWidth),
  });

  final Widget child;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Dialog(constraints: constraints, child: child);
  }
}

/// Standard header layout for an Oma dialog.
class OmaDialogHeader extends StatelessWidget {
  const OmaDialogHeader({
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
        OmaSpacing.xl,
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
          if (showCloseButton) const OmaDialogClose(),
        ],
      ),
    );
  }
}

/// Standard title typography for an Oma dialog.
class OmaDialogTitle extends StatelessWidget {
  const OmaDialogTitle(this.data, {super.key});

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

/// Standard supporting typography for an Oma dialog.
class OmaDialogDescription extends StatelessWidget {
  const OmaDialogDescription(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: OmaText.body(OmaTypeScale.body, color: context.omaTheme.muted),
    );
  }
}

/// Localized close action that can return a generic result.
class OmaDialogClose<T extends Object?> extends StatelessWidget {
  const OmaDialogClose({super.key, this.result});

  final T? result;

  @override
  Widget build(BuildContext context) {
    return OmaIconButton(
      icon: Icons.close,
      size: OmaSpacing.massive,
      iconSize: OmaSpacing.xl,
      semanticLabel: MaterialLocalizations.of(context).closeButtonTooltip,
      onPressed: () => Navigator.of(context).maybePop<T>(result),
    );
  }
}

/// Padding-only content primitive with no feature or scrolling behavior.
class OmaDialogContent extends StatelessWidget {
  const OmaDialogContent({
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

/// Action-area layout primitive for an Oma dialog.
class OmaDialogFooter extends StatelessWidget {
  const OmaDialogFooter({
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

    return ColoredBox(
      color: oma.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDivider) const OmaDivider(),
          Padding(
            padding: padding,
            child: SizedBox(width: double.infinity, child: child),
          ),
        ],
      ),
    );
  }
}
