import 'package:flutter/material.dart';

import '../../../../core/widgets/index.dart';
import '../../../../localization/generated/strings.g.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    super.key,
    required this.canContinue,
    required this.onContinue,
    required this.onSkip,
    required this.isFirst,
    required this.isLast,
    required this.isSkippable,
  });

  final bool canContinue;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  final bool isFirst;
  final bool isLast;
  final bool isSkippable;

  @override
  Widget build(BuildContext context) {
    final common = context.t.onboarding.common;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OmaButton(
          label: isLast ? common.finish : common.next,
          onPressed: canContinue ? onContinue : null,
        ),
        const SizedBox(height: 12),
        if (isFirst)
          Text(
            common.swipeToContinue,
            textAlign: TextAlign.center,
            style: OmaText.body(
              12,
              color: OmaColors.muted,
            ),
          )
        else if (isSkippable)
          OmaButton(
            label: common.skipForNow,
            variant: OmaButtonVariant.text,
            trailingIcon: null,
            onPressed: onSkip,
          ),
      ],
    );
  }
}