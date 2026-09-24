import 'package:flutter/material.dart';

import '../theme/oma_theme.dart';

enum OmaButtonVariant {
  primary,
  secondary,
  outline,

  /// Uses a solid Material outline. A true dashed stroke would require a
  /// separate custom-rendering design decision.
  dashed,
  text,
}

enum OmaButtonSize { small, medium, large }

/// Oma's Material-based standard action button.
class OmaButton extends StatelessWidget {
  const OmaButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = OmaButtonVariant.primary,
    this.size = OmaButtonSize.medium,
    this.trailingIcon,
    this.leadingIcon,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final OmaButtonVariant variant;
  final OmaButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  /// Prevents interaction while retaining the active visual treatment and
  /// the original content width.
  final bool isLoading;

  final Color? backgroundColor;
  final Color? foregroundColor;

  bool get _isEnabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;
    final metrics = _OmaButtonMetrics.forSize(size);
    final button = _buildMaterialButton(
      oma: oma,
      metrics: metrics,
      child: _buildChild(oma, metrics),
    );
    final shadows = _resolveShadows(oma);

    if (shadows == null) return button;

    // Oma's colored blur/offset shadows cannot be represented exactly by
    // Material elevation, so only the variants that need them get a wrapper.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(OmaRadius.full),
        boxShadow: shadows,
      ),
      child: button,
    );
  }

  Widget _buildMaterialButton({
    required OmaTheme oma,
    required _OmaButtonMetrics metrics,
    required Widget child,
  }) {
    final style = _resolveStyle(oma, metrics);
    final effectiveOnPressed = isLoading ? null : onPressed;

    return switch (variant) {
      OmaButtonVariant.primary || OmaButtonVariant.secondary => FilledButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
      OmaButtonVariant.outline || OmaButtonVariant.dashed => OutlinedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
      OmaButtonVariant.text => TextButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
    };
  }

  Widget _buildChild(OmaTheme oma, _OmaButtonMetrics metrics) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: metrics.iconSize),
          SizedBox(width: metrics.gap),
        ],
        Text(label),
        if (trailingIcon != null) ...[
          SizedBox(width: metrics.gap),
          Icon(trailingIcon, size: metrics.iconSize),
        ],
      ],
    );

    if (!isLoading) return content;

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0, child: content),
        SizedBox.square(
          dimension: metrics.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: _resolveForegroundColor(oma),
          ),
        ),
      ],
    );
  }

  ButtonStyle _resolveStyle(OmaTheme oma, _OmaButtonMetrics metrics) {
    final foreground = _resolveForegroundColor(oma);
    final background = _resolveBackgroundColor(oma);
    final loadingBackground = isLoading ? background : null;
    final loadingForeground = isLoading ? foreground : null;
    final common = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.fromHeight(metrics.height)),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: metrics.horizontalPadding),
      ),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      elevation: const WidgetStatePropertyAll(0),
      textStyle: WidgetStatePropertyAll(
        OmaText.body(metrics.fontSize, weight: FontWeight.w500),
      ),
    );

    final variantStyle = switch (variant) {
      OmaButtonVariant.primary ||
      OmaButtonVariant.secondary => FilledButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        disabledBackgroundColor: loadingBackground,
        disabledForegroundColor: loadingForeground,
      ),
      OmaButtonVariant.outline => OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foreground,
        disabledBackgroundColor: isLoading ? backgroundColor : null,
        disabledForegroundColor: loadingForeground,
        side: BorderSide(color: oma.border),
      ),
      OmaButtonVariant.dashed => OutlinedButton.styleFrom(
        backgroundColor: backgroundColor ?? oma.primary.withValues(alpha: 0.04),
        foregroundColor: foreground,
        disabledBackgroundColor: isLoading
            ? backgroundColor ?? oma.primary.withValues(alpha: 0.04)
            : null,
        disabledForegroundColor: loadingForeground,
        side: BorderSide(color: oma.primary.withValues(alpha: 0.4)),
      ),
      OmaButtonVariant.text => TextButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foreground,
        disabledBackgroundColor: isLoading ? backgroundColor : null,
        disabledForegroundColor: loadingForeground,
      ),
    };

    return variantStyle.merge(common);
  }

  Color? _resolveBackgroundColor(OmaTheme oma) {
    if (backgroundColor != null) return backgroundColor;

    return switch (variant) {
      OmaButtonVariant.primary => oma.primary,
      OmaButtonVariant.secondary => oma.surface,
      OmaButtonVariant.outline ||
      OmaButtonVariant.dashed ||
      OmaButtonVariant.text => null,
    };
  }

  Color _resolveForegroundColor(OmaTheme oma) {
    if (foregroundColor != null) return foregroundColor!;

    return switch (variant) {
      OmaButtonVariant.primary => oma.onPrimary,
      OmaButtonVariant.secondary => oma.primary,
      OmaButtonVariant.outline => oma.foreground,
      OmaButtonVariant.dashed => oma.primary,
      OmaButtonVariant.text => oma.muted,
    };
  }

  List<BoxShadow>? _resolveShadows(OmaTheme oma) {
    if (!_isEnabled) return null;

    return switch (variant) {
      OmaButtonVariant.primary => OmaShadows.elevated(
        backgroundColor ?? oma.primary,
      ),
      OmaButtonVariant.secondary => oma.softShadow,
      OmaButtonVariant.outline ||
      OmaButtonVariant.dashed ||
      OmaButtonVariant.text => null,
    };
  }
}

@immutable
class _OmaButtonMetrics {
  const _OmaButtonMetrics({
    required this.height,
    required this.horizontalPadding,
    required this.fontSize,
    required this.iconSize,
    required this.gap,
  });

  final double height;
  final double horizontalPadding;
  final double fontSize;
  final double iconSize;
  final double gap;

  static const small = _OmaButtonMetrics(
    height: 40,
    horizontalPadding: OmaSpacing.lg,
    fontSize: OmaTypeScale.caption,
    iconSize: 14,
    gap: 10,
  );

  static const medium = _OmaButtonMetrics(
    height: 50,
    horizontalPadding: OmaSpacing.xl,
    fontSize: OmaTypeScale.body,
    iconSize: 17,
    gap: 10,
  );

  static const large = _OmaButtonMetrics(
    height: 56,
    horizontalPadding: OmaSpacing.xxl,
    fontSize: OmaTypeScale.bodyLarge,
    iconSize: 18,
    gap: 10,
  );

  static _OmaButtonMetrics forSize(OmaButtonSize size) {
    return switch (size) {
      OmaButtonSize.small => small,
      OmaButtonSize.medium => medium,
      OmaButtonSize.large => large,
    };
  }
}
