import 'package:flutter/material.dart';

import 'oma_theme.dart';

enum OnboardingDeckMotion { none, next, prev }

/// Content card used in the onboarding deck.
///
/// Provides the card surface, scrolling and directional
/// entrance animation while keeping the content layout flexible.
class OnboardingCard extends StatelessWidget {
  const OnboardingCard({
    super.key,
    required this.label,
    required this.children,
    this.motion = OnboardingDeckMotion.none,
    this.duration = const Duration(milliseconds: 350),
    this.margin = const EdgeInsets.fromLTRB(20, 8, 20, 4),
    this.padding = const EdgeInsets.all(20),
    this.itemSpacing = 8,
  });

  final String label;
  final List<Widget> children;

  final OnboardingDeckMotion motion;
  final Duration duration;

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double itemSpacing;

  @override
  Widget build(BuildContext context) {
    final beginOffset = switch (motion) {
      OnboardingDeckMotion.next => const Offset(0.04, 0),
      OnboardingDeckMotion.prev => const Offset(-0.04, 0),
      OnboardingDeckMotion.none => Offset.zero,
    };

    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ),
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
            border: Border.all(
              color: const Color(0xFFE3DFD7),
              width: 1,
            ),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: OmaText.body(
                  11,
                  weight: FontWeight.w500,
                  letterSpacing: 1.6,
                  color: OmaColors.muted,
                ),
              ),
              const SizedBox(height: 16),
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  SizedBox(height: itemSpacing),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
