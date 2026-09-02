import 'package:flutter/material.dart';

import '../../../../core/constants/color_constants.dart';
import '../../../../localization/generated/strings.g.dart';
import 'onboarding_typography.dart';

class OnboardingSelectionSheet extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accent;
  final Widget child;
  final VoidCallback onSave;

  const OnboardingSelectionSheet({
    super.key,
    required this.title,
    required this.icon,
    required this.accent,
    required this.child,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.92,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 10),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: accent, size: 20),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Text(
                      title,
                      style: OnboardingTypography.displayHeading,
                    ),
                  ),
                  IconButton(
                    key: const ValueKey('onboarding_selection_close'),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                children: [child],
              ),
            ),
            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onSave,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    textStyle: OnboardingTypography.button,
                  ),
                  child: Text(context.t.onboarding.common.save),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
