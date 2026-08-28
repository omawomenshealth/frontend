import 'package:flutter/material.dart';

enum OnboardingDeckMotion { none, next, prev }

class OnboardingDeckCard extends StatelessWidget {
  final String eyebrow;
  final Widget child;
  final OnboardingDeckMotion motion;
  final Duration duration;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const OnboardingDeckCard({
    super.key,
    required this.eyebrow,
    required this.child,
    this.motion = OnboardingDeckMotion.none,
    this.duration = const Duration(milliseconds: 350),
    this.margin = const EdgeInsets.fromLTRB(20, 8, 20, 4),
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    final beginOffset = switch (motion) {
      OnboardingDeckMotion.next => const Offset(0.04, 0),
      OnboardingDeckMotion.prev => const Offset(-0.04, 0),
      OnboardingDeckMotion.none => Offset.zero,
    };

    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(begin: beginOffset, end: Offset.zero),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(offset.dx * 100, 0),
          child: child,
        );
      },
      child: SingleChildScrollView(
        padding: margin,
        child: Container(
          width: double.infinity,
          padding: padding,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE3DFD7), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A5E5A52),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: const TextStyle(
                  color: Color(0xFF7A756C),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
