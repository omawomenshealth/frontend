import 'package:flutter/material.dart';

import '../../../../core/widgets/index.dart';
import '../../../../localization/generated/strings.g.dart';
import '../widgets/index.dart';

class WellbeingPage extends StatefulWidget {
  const WellbeingPage({
    super.key,
  });

  @override
  State<WellbeingPage> createState() => _WellbeingPageState();
}

class _WellbeingPageState extends State<WellbeingPage> {
  Set<String> _moods = <String>{};
  Set<String> _supportNeeds = <String>{};

  @override
  Widget build(BuildContext context) {
    final wellbeing = context.t.onboarding.wellbeing;

    return OnboardingCard(
      label: wellbeing.title,
      children: [
        OmaField(
          label: wellbeing.moodQuestion,
          child: OmaMultiSelect<String>(
            options: [
              wellbeing.moodOptions.good,
              wellbeing.moodOptions.tired,
              wellbeing.moodOptions.anxious,
              wellbeing.moodOptions.pain,
            ],
            selectedValues: _moods,
            labelBuilder: (value) => value,
            onChanged: (next) {
              setState(() {
                _moods = next;
              });
            },
          ),
        ),
        OmaField(
          label: wellbeing.supportQuestion,
          hint: wellbeing.multiSelectHint,
          child: OmaMultiSelect<String>(
            options: [
              wellbeing.supportOptions.relievePain,
              wellbeing.supportOptions.recoverEnergy,
              wellbeing.supportOptions.calmAnxiety,
              wellbeing.supportOptions.improveSleep,
              wellbeing.supportOptions.understandCycle,
              wellbeing.supportOptions.justListen,
            ],
            selectedValues: _supportNeeds,
            labelBuilder: (value) => value,
            onChanged: (next) {
              setState(() {
                _supportNeeds = next;
              });
            },
          ),
        ),
      ],
    );
  }
}
