import 'package:flutter/material.dart';

import 'oma_theme.dart';

enum OmaButtonVariant {
  primary,
  secondary,
  outline,
  dashed,
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
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;

  final OmaButtonVariant variant;
  final OmaButtonSize size;

  final IconData? leadingIcon;
  final IconData? trailingIcon;

  /// true olduğunda buton etkileşimi engellenir, içerik yerini ortalanmış
  /// bir spinner'a bırakır ama buton rengi/boyutu değişmez — bu sayede
  /// yükleme sırasında düzen (layout) zıplaması olmaz.
  final bool isLoading;

  /// Kullanıcı etkileşimine açık mı (dokunma amaçlı).
  bool get _interactive => onPressed != null && !isLoading;

  /// Görsel olarak "aktif" mi — yükleme sırasında da true kalır, böylece
  /// buton soluklaşmaz; sadece gerçekten devre dışıyken (onPressed null ve
  /// yükleme yokken) soluklaşır.
  bool get _visuallyActive => onPressed != null;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _visuallyActive ? 1 : 0.4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          boxShadow: _boxShadow(_visuallyActive),
        ),
        child: _buildButton(),
      ),
    );
  }

  Widget _buildButton() {
    final style = _buttonStyle();
    final child = _buildChild();

    return switch (variant) {
      OmaButtonVariant.primary ||
      OmaButtonVariant.secondary =>
        FilledButton(
          onPressed: _interactive ? onPressed : null,
          style: style,
          child: child,
        ),

      OmaButtonVariant.outline ||
      OmaButtonVariant.dashed =>
        OutlinedButton(
          onPressed: _interactive ? onPressed : null,
          style: style,
          child: child,
        ),

      OmaButtonVariant.text =>
        TextButton(
          onPressed: _interactive ? onPressed : null,
          style: style,
          child: child,
        ),
    };
  }

  Widget _buildChild() {
    final content = _buildContent();

    if (!isLoading) return content;

    // İçeriği görünmez tutup üstüne spinner bindirerek buton genişliğini
    // sabit tutuyoruz; aksi halde metin kaybolunca buton daralır/zıplar.
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: 0, child: content),
        SizedBox(
          width: _iconSize,
          height: _iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(_foregroundColor),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final children = <Widget>[];

    if (leadingIcon != null) {
      children.add(
        Icon(
          leadingIcon,
          size: _iconSize,
        ),
      );
      children.add(const SizedBox(width: 10));
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
      children.add(const SizedBox(width: 10));
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
    // Yükleme sırasında onPressed'i null yaparak dokunmayı engelliyoruz;
    // ama görsel olarak "disabled" (soluk/gri) görünmesini istemiyoruz.
    // Bu yüzden isLoading true iken normal renkleri disabled state'e de
    // açıkça set ediyoruz.
    final keepColorsWhileLoading = isLoading;

    return switch (variant) {
      OmaButtonVariant.primary => FilledButton.styleFrom(
          backgroundColor: OmaColors.primary,
          foregroundColor: OmaColors.primaryForeground,
          disabledBackgroundColor:
              keepColorsWhileLoading ? OmaColors.primary : null,
          disabledForegroundColor:
              keepColorsWhileLoading ? OmaColors.primaryForeground : null,
          minimumSize: Size.fromHeight(_height),
          padding: _padding,
          shape: const StadiumBorder(),
        ),

      OmaButtonVariant.secondary => FilledButton.styleFrom(
          backgroundColor: OmaColors.card,
          foregroundColor: OmaColors.primary,
          disabledBackgroundColor:
              keepColorsWhileLoading ? OmaColors.card : null,
          disabledForegroundColor:
              keepColorsWhileLoading ? OmaColors.primary : null,
          minimumSize: Size.fromHeight(_height),
          padding: _padding,
          shape: const StadiumBorder(),
        ),

      OmaButtonVariant.outline => OutlinedButton.styleFrom(
          foregroundColor: OmaColors.foreground,
          disabledForegroundColor:
              keepColorsWhileLoading ? OmaColors.foreground : null,
          minimumSize: Size.fromHeight(_height),
          padding: _padding,
          shape: const StadiumBorder(),
          side: BorderSide(
            color: OmaColors.border,
          ),
        ),

      OmaButtonVariant.dashed => OutlinedButton.styleFrom(
          foregroundColor: OmaColors.primary,
          backgroundColor: OmaColors.primary.withValues(alpha: 0.04),
          disabledForegroundColor:
              keepColorsWhileLoading ? OmaColors.primary : null,
          disabledBackgroundColor: keepColorsWhileLoading
              ? OmaColors.primary.withValues(alpha: 0.04)
              : null,
          minimumSize: Size.fromHeight(_height),
          padding: _padding,
          shape: const StadiumBorder(),
          side: BorderSide(
            color: OmaColors.primary.withValues(alpha: 0.4),
          ),
        ),

      OmaButtonVariant.text => TextButton.styleFrom(
          foregroundColor: OmaColors.muted,
          disabledForegroundColor:
              keepColorsWhileLoading ? OmaColors.muted : null,
          minimumSize: Size.fromHeight(_height),
          padding: _padding,
          shape: const StadiumBorder(),
        ),
    };
  }

  List<BoxShadow>? _boxShadow(bool visuallyActive) {
    if (!visuallyActive) return null;

    return switch (variant) {
      OmaButtonVariant.primary => OmaShadows.lift,
      OmaButtonVariant.secondary => OmaShadows.soft,
      OmaButtonVariant.outline ||
      OmaButtonVariant.dashed ||
      OmaButtonVariant.text => null,
    };
  }

  Color get _foregroundColor {
    return switch (variant) {
      OmaButtonVariant.primary => OmaColors.primaryForeground,
      OmaButtonVariant.secondary => OmaColors.primary,
      OmaButtonVariant.outline => OmaColors.foreground,
      OmaButtonVariant.dashed => OmaColors.primary,
      OmaButtonVariant.text => OmaColors.muted,
    };
  }

  double get _height {
    return switch (size) {
      OmaButtonSize.small => 40,
      OmaButtonSize.medium => 50,
      OmaButtonSize.large => 56,
    };
  }

  EdgeInsetsGeometry get _padding {
    return switch (size) {
      OmaButtonSize.small => const EdgeInsets.symmetric(horizontal: 16),
      OmaButtonSize.medium => const EdgeInsets.symmetric(horizontal: 20),
      OmaButtonSize.large => const EdgeInsets.symmetric(horizontal: 24),
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
      OmaButtonSize.medium => 17,
      OmaButtonSize.large => 18,
    };
  }
}