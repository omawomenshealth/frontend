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
  Set<String> _supportNeeds = <String>{};

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return OnboardingDeckCard(
      eyebrow: t.onboarding.wellbeing.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          OnboardingQuestion(
            question: t.onboarding.wellbeing.moodQuestion,
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
          OnboardingQuestion(
            question: t.onboarding.wellbeing.supportQuestion,
            helper: t.onboarding.wellbeing.multiSelectHint,
            child: OnboardingMultiSelect(
              options: [
                t.onboarding.wellbeing.supportOptions.relievePain,
                t.onboarding.wellbeing.supportOptions.recoverEnergy,
                t.onboarding.wellbeing.supportOptions.calmAnxiety,
                t.onboarding.wellbeing.supportOptions.improveSleep,
                t.onboarding.wellbeing.supportOptions.understandCycle,
                t.onboarding.wellbeing.supportOptions.justListen,
              ],
              selectedValues: _supportNeeds,
              onChanged: (next) => setState(() => _supportNeeds = next),
              spacing: 8,
              runSpacing: 8,
            ),
          ),
        ],
      ),
    );
  }
}