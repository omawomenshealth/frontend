import 'package:flutter/material.dart';
import '../constants/color_constants.dart';

/// Gradient arka planlı, scale animasyonlu özel buton.
class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color textColor;
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
    this.textColor = AppColors.textOnPrimary,
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: widget.backgroundColor ?? AppColors.primary,
                    width: 1.5,
                  ),
                )
              : BoxDecoration(
                  gradient: widget.gradient ?? AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.backgroundColor ?? AppColors.primary)
                          .withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: widget.isOutlined
                          ? AppColors.primary
                          : widget.textColor,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          color: widget.isOutlined
                              ? (widget.backgroundColor ?? AppColors.primary)
                              : widget.textColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style: TextStyle(
                          color: widget.isOutlined
                              ? (widget.backgroundColor ?? AppColors.primary)
                              : widget.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
