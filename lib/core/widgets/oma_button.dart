import 'package:flutter/material.dart';

import 'oma_theme.dart';

enum OmaButtonVariant {
  primary,
  secondary,
  outline,
  text,
}

enum OmaButtonSize {
  small,
  medium,
  large,
}

/// Oma'nın standart eylem butonu.
class OmaButton extends StatelessWidget {
  const OmaButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = OmaButtonVariant.primary,
    this.size = OmaButtonSize.medium,
    this.trailingIcon,
    this.leadingIcon,
  });

  final String label;
  final VoidCallback? onPressed;

  final OmaButtonVariant variant;
  final OmaButtonSize size;

  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          boxShadow: _boxShadow(enabled),
        ),
        child: _buildButton(),
      ),
    );
  }

  Widget _buildButton() {
    final style = _buttonStyle();

    final child = _buildChild();

    switch (variant) {
      case OmaButtonVariant.primary:
      case OmaButtonVariant.secondary:
        return FilledButton(
          onPressed: onPressed,
          style: style,
          child: child,
        );

      case OmaButtonVariant.outline:
        return OutlinedButton(
          onPressed: onPressed,
          style: style,
          child: child,
        );

      case OmaButtonVariant.text:
        return TextButton(
          onPressed: onPressed,
          style: style,
          child: child,
        );
    }
  }

  Widget _buildChild() {
    final children = <Widget>[];

    if (leadingIcon != null) {
      children.add(
        Icon(
          leadingIcon,
          size: _iconSize,
        ),
      );
      children.add(const SizedBox(width: 8));
    }

    children.add(
      Text(
        label,
        style: OmaText.body(
          _fontSize,
          weight: FontWeight.w500,
          color: _foregroundColor,
        ),
      ),
    );

    if (trailingIcon != null) {
      children.add(const SizedBox(width: 8));
      children.add(
        Icon(
          trailingIcon,
          size: _iconSize,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  ButtonStyle _buttonStyle() {
    return switch (variant) {
      OmaButtonVariant.primary => FilledButton.styleFrom(
          backgroundColor: OmaColors.primary,
          foregroundColor: OmaColors.primaryForeground,
          minimumSize: Size.fromHeight(_height),
          padding: _padding,
          shape: const StadiumBorder(),
        ),

      OmaButtonVariant.secondary => FilledButton.styleFrom(
          backgroundColor: OmaColors.card,
          foregroundColor: OmaColors.primary,
          minimumSize: Size.fromHeight(_height),
          padding: _padding,
          shape: const StadiumBorder(),
        ),

      OmaButtonVariant.outline => OutlinedButton.styleFrom(
          foregroundColor: OmaColors.primary,
          minimumSize: Size.fromHeight(_height),
          padding: _padding,
          shape: const StadiumBorder(),
          side: BorderSide(
            color: OmaColors.primary.withValues(alpha: 0.5),
          ),
        ),

      OmaButtonVariant.text => TextButton.styleFrom(
          foregroundColor: OmaColors.muted,
          minimumSize: Size.fromHeight(_height),
          padding: _padding,
          shape: const StadiumBorder(),
        ),
    };
  }

  List<BoxShadow>? _boxShadow(bool enabled) {
    if (!enabled) return null;

    return switch (variant) {
      OmaButtonVariant.primary => OmaShadows.lift,
      OmaButtonVariant.secondary => OmaShadows.soft,
      OmaButtonVariant.outline => null,
      OmaButtonVariant.text => null,
    };
  }

  Color get _foregroundColor {
    return switch (variant) {
      OmaButtonVariant.primary => OmaColors.primaryForeground,
      OmaButtonVariant.secondary => OmaColors.primary,
      OmaButtonVariant.outline => OmaColors.primary,
      OmaButtonVariant.text => OmaColors.muted,
    };
  }

  double get _height {
    return switch (size) {
      OmaButtonSize.small => 40,
      OmaButtonSize.medium => 48,
      OmaButtonSize.large => 56,
    };
  }

  EdgeInsetsGeometry get _padding {
    return switch (size) {
      OmaButtonSize.small =>
        const EdgeInsets.symmetric(horizontal: 16),
      OmaButtonSize.medium =>
        const EdgeInsets.symmetric(horizontal: 20),
      OmaButtonSize.large =>
        const EdgeInsets.symmetric(horizontal: 24),
    };
  }

  double get _fontSize {
    return switch (size) {
      OmaButtonSize.small => 12,
      OmaButtonSize.medium => 14,
      OmaButtonSize.large => 16,
    };
  }

  double get _iconSize {
    return switch (size) {
      OmaButtonSize.small => 14,
      OmaButtonSize.medium => 16,
      OmaButtonSize.large => 18,
    };
  }
}