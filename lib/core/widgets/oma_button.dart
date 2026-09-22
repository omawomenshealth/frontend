import 'package:flutter/material.dart';

import '../theme/oma_theme.dart';

enum OmaButtonVariant { primary, secondary, outline, dashed, text }

enum OmaButtonSize { small, medium, large }

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
    this.backgroundColor,
    this.foregroundColor,
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
  final Color? backgroundColor;
  final Color? foregroundColor;

  /// Kullanıcı etkileşimine açık mı (dokunma amaçlı).
  bool get _interactive => onPressed != null && !isLoading;

  /// Görsel olarak "aktif" mi — yükleme sırasında da true kalır, böylece
  /// buton soluklaşmaz; sadece gerçekten devre dışıyken (onPressed null ve
  /// yükleme yokken) soluklaşır.
  bool get _visuallyActive => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;
    return Opacity(
      opacity: _visuallyActive ? 1 : 0.4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          boxShadow: _boxShadow(_visuallyActive),
        ),
        child: _buildButton(oma),
      ),
    );
  }

  Widget _buildButton(OmaTheme oma) {
    final style = _buttonStyle(oma);
    final child = _buildChild(oma);

    return switch (variant) {
      OmaButtonVariant.primary || OmaButtonVariant.secondary => FilledButton(
        onPressed: _interactive ? onPressed : null,
        style: style,
        child: child,
      ),

      OmaButtonVariant.outline || OmaButtonVariant.dashed => OutlinedButton(
        onPressed: _interactive ? onPressed : null,
        style: style,
        child: child,
      ),

      OmaButtonVariant.text => TextButton(
        onPressed: _interactive ? onPressed : null,
        style: style,
        child: child,
      ),
    };
  }

  Widget _buildChild(OmaTheme oma) {
    final content = _buildContent(oma);

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
            valueColor: AlwaysStoppedAnimation<Color>(_foregroundColor(oma)),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(OmaTheme oma) {
    final children = <Widget>[];

    if (leadingIcon != null) {
      children.add(Icon(leadingIcon, size: _iconSize));
      children.add(const SizedBox(width: 10));
    }

    children.add(
      Text(
        label,
        style: OmaText.body(
          _fontSize,
          weight: FontWeight.w500,
          color: _foregroundColor(oma),
        ),
      ),
    );

    if (trailingIcon != null) {
      children.add(const SizedBox(width: 10));
      children.add(Icon(trailingIcon, size: _iconSize));
    }

    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  ButtonStyle _buttonStyle(OmaTheme oma) {
    // Yükleme sırasında onPressed'i null yaparak dokunmayı engelliyoruz;
    // ama görsel olarak "disabled" (soluk/gri) görünmesini istemiyoruz.
    // Bu yüzden isLoading true iken normal renkleri disabled state'e de
    // açıkça set ediyoruz.
    final keepColorsWhileLoading = isLoading;

    return switch (variant) {
      OmaButtonVariant.primary => FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? oma.primary,
        foregroundColor: foregroundColor ?? oma.onPrimary,
        disabledBackgroundColor: keepColorsWhileLoading
            ? backgroundColor ?? oma.primary
            : null,
        disabledForegroundColor: keepColorsWhileLoading
            ? foregroundColor ?? oma.onPrimary
            : null,
        minimumSize: Size.fromHeight(_height),
        padding: _padding,
        shape: const StadiumBorder(),
      ),

      OmaButtonVariant.secondary => FilledButton.styleFrom(
        backgroundColor: oma.surface,
        foregroundColor: oma.primary,
        disabledBackgroundColor: keepColorsWhileLoading ? oma.surface : null,
        disabledForegroundColor: keepColorsWhileLoading ? oma.primary : null,
        minimumSize: Size.fromHeight(_height),
        padding: _padding,
        shape: const StadiumBorder(),
      ),

      OmaButtonVariant.outline => OutlinedButton.styleFrom(
        foregroundColor: oma.foreground,
        disabledForegroundColor: keepColorsWhileLoading ? oma.foreground : null,
        minimumSize: Size.fromHeight(_height),
        padding: _padding,
        shape: const StadiumBorder(),
        side: BorderSide(color: oma.border),
      ),

      OmaButtonVariant.dashed => OutlinedButton.styleFrom(
        foregroundColor: oma.primary,
        backgroundColor: oma.primary.withValues(alpha: 0.04),
        disabledForegroundColor: keepColorsWhileLoading ? oma.primary : null,
        disabledBackgroundColor: keepColorsWhileLoading
            ? oma.primary.withValues(alpha: 0.04)
            : null,
        minimumSize: Size.fromHeight(_height),
        padding: _padding,
        shape: const StadiumBorder(),
        side: BorderSide(color: oma.primary.withValues(alpha: 0.4)),
      ),

      OmaButtonVariant.text => TextButton.styleFrom(
        foregroundColor: oma.muted,
        disabledForegroundColor: keepColorsWhileLoading ? oma.muted : null,
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

  Color _foregroundColor(OmaTheme oma) {
    if (foregroundColor != null) return foregroundColor!;

    return switch (variant) {
      OmaButtonVariant.primary => oma.onPrimary,
      OmaButtonVariant.secondary => oma.primary,
      OmaButtonVariant.outline => oma.foreground,
      OmaButtonVariant.dashed => oma.primary,
      OmaButtonVariant.text => oma.muted,
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

/// OMA tasarım token'larını kullanan, yalnızca ikon içeren eylem butonu.
class OmaIconButton extends StatelessWidget {
  const OmaIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.size = 46,
    this.iconSize = 20,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String semanticLabel;
  final double size;
  final double iconSize;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: IconButton(
        onPressed: onPressed,
        tooltip: semanticLabel,
        style: IconButton.styleFrom(
          fixedSize: Size.square(size),
          foregroundColor: foregroundColor ?? oma.primary,
          backgroundColor: backgroundColor ?? oma.primarySoft,
          side: borderColor == null ? null : BorderSide(color: borderColor!),
        ),
        icon: Icon(icon, size: iconSize),
      ),
    );
  }
}
