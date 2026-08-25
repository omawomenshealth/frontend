import 'package:flutter/material.dart';

import '../../../../localization/generated/strings.g.dart';
import '../widgets/index.dart';

class WellbeingPage extends StatefulWidget {
  const WellbeingPage({super.key});

  @override
  State<WellbeingPage> createState() => _WellbeingPageState();
}

class _WellbeingPageState extends State<WellbeingPage> {
  Set<String> _moods = <String>{};

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return OnboardingDeckCard(
      eyebrow: t.onboarding.wellbeing.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingFieldLabel(t.onboarding.wellbeing.moodQuestion),
          const SizedBox(height: 12),
          OnboardingMultiSelect(
            options: [
              t.onboarding.wellbeing.moodOptions.good,
              t.onboarding.wellbeing.moodOptions.tired,
              t.onboarding.wellbeing.moodOptions.anxious,
              t.onboarding.wellbeing.moodOptions.pain,
            ],
            selectedValues: _moods,
            onChanged: (next) => setState(() => _moods = next),
            maxSelection: 3,
          ),
          const SizedBox(height: 10),
          Text(
            t.onboarding.wellbeing.multiSelectHint,
            style: const TextStyle(
              color: Color(0xFF7A756C),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}