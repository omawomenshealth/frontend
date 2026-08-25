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
      child: OnboardingQuestion(
        question: t.onboarding.wellbeing.moodQuestion,
        helper: t.onboarding.wellbeing.multiSelectHint,
        child: OnboardingMultiSelect(
          options: [
            t.onboarding.wellbeing.moodOptions.good,
            t.onboarding.wellbeing.moodOptions.tired,
            t.onboarding.wellbeing.moodOptions.anxious,
            t.onboarding.wellbeing.moodOptions.pain,
          ],
          selectedValues: _moods,
          onChanged: (next) => setState(() => _moods = next),
        ),
      ),
    );
  }
}