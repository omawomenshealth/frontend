import 'package:flutter/material.dart';

import '../../../../core/widgets/index.dart';
import '../../../../localization/generated/strings.g.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';

class WellbeingPage extends StatelessWidget {
  const WellbeingPage({super.key, required this.vm});

  final OnboardingViewModel vm;

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
            selectedValues: vm.moods,
            labelBuilder: (value) => value,
            onChanged: vm.setMoods,
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
            selectedValues: vm.supportNeeds,
            labelBuilder: (value) => value,
            onChanged: vm.setSupportNeeds,
          ),
        ),
      ],
    );
  }
}
