import 'package:flutter/material.dart';
import '../theme/oma_theme.dart';

/// Gradient arka planlı, scale animasyonlu özel buton.
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 52,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;
    final buttonColor = widget.backgroundColor ?? oma.primary;
    final contentColor = widget.textColor ?? oma.onPrimary;
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          if (!widget.isLoading) widget.onPressed();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: widget.isOutlined
              ? BoxDecoration(
                  color: oma.surface,
                  borderRadius: BorderRadius.circular(OmaRadius.full),
                  border: Border.all(color: buttonColor, width: 1.2),
                )
              : BoxDecoration(
                  gradient:
                      widget.gradient ??
                      (widget.backgroundColor == null
                          ? LinearGradient(
                              colors: [oma.primary, oma.primaryStrong],
                            )
                          : null),
                  color: widget.gradient == null
                      ? widget.backgroundColor
                      : null,
                  borderRadius: BorderRadius.circular(OmaRadius.full),
                  boxShadow: OmaShadows.soft(buttonColor),
                ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: widget.isOutlined ? oma.primary : contentColor,
                      strokeWidth: 2.5,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: OmaSpacing.lg,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: widget.isOutlined
                                ? buttonColor
                                : contentColor,
                            size: 20,
                          ),
                          const SizedBox(width: OmaSpacing.sm),
                        ],
                        Flexible(
                          child: Text(
                            widget.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: widget.isOutlined
                                  ? buttonColor
                                  : contentColor,
                              fontSize: OmaTypeScale.bodyLarge,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
