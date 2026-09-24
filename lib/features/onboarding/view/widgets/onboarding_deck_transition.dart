import 'package:flutter/material.dart';

enum OnboardingDeckMotion { none, next, prev }

/// Applies the directional entrance motion used by onboarding pages.
class OnboardingDeckTransition extends StatelessWidget {
  const OnboardingDeckTransition({
    super.key,
    required this.child,
    this.motion = OnboardingDeckMotion.none,
    this.duration = const Duration(milliseconds: 350),
  });

  final Widget child;
  final OnboardingDeckMotion motion;
  final Duration duration;

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
      child: child,
    );
  }
}
