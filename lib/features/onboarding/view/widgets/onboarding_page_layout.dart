import 'package:flutter/material.dart';

import '../../../../core/widgets/index.dart';
import 'onboarding_deck_transition.dart';

/// Shared page composition for onboarding questions.
class OnboardingPageLayout extends StatelessWidget {
  const OnboardingPageLayout({
    super.key,
    required this.label,
    required this.children,
    this.motion = OnboardingDeckMotion.none,
    this.duration = const Duration(milliseconds: 350),
    this.margin = const EdgeInsets.symmetric(horizontal: OmaSpacing.xl),
    this.itemSpacing = 8,
  });

  final String label;
  final List<Widget> children;
  final OnboardingDeckMotion motion;
  final Duration duration;
  final EdgeInsetsGeometry margin;
  final double itemSpacing;

  @override
  Widget build(BuildContext context) {
    return OnboardingDeckTransition(
      motion: motion,
      duration: duration,
      child: SingleChildScrollView(
        child: Padding(
          padding: margin,
          child: OmaCard(
            child: OmaCardContent(
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
                      color: context.omaTheme.muted,
                    ),
                  ),
                  const SizedBox(height: OmaSpacing.lg),
                  for (int i = 0; i < children.length; i++) ...[
                    children[i],
                    if (i < children.length - 1) SizedBox(height: itemSpacing),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
