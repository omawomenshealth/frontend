import 'package:flutter/material.dart';

class OnboardingSoftOrb extends StatelessWidget {
  final Color color;
  final double size;

  const OnboardingSoftOrb({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.075),
          border: Border.all(color: color.withValues(alpha: 0.08), width: 12),
        ),
      ),
    );
  }
}