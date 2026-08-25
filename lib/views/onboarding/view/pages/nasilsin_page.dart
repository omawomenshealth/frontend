import 'package:flutter/material.dart';
import '../../../../localization/generated/strings.g.dart';

import '../widgets/index.dart';

class NasilsinPage extends StatefulWidget {
  const NasilsinPage({super.key});

  @override
  State<NasilsinPage> createState() => _NasilsinPageState();
}

class _NasilsinPageState extends State<NasilsinPage> {
  Set<String> _moods = <String>{};

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return OnboardingDeckCard(
      eyebrow: t.onboarding.howAreYou.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          OnboardingFieldLabel(t.onboarding.howAreYou.moodQuestion),
          const SizedBox(height: 12),
          OnboardingMultiSelect(
            options: [
              t.onboarding.howAreYou.moodOptions.good,
              t.onboarding.howAreYou.moodOptions.tired,
              t.onboarding.howAreYou.moodOptions.anxious,
              t.onboarding.howAreYou.moodOptions.pain,
            ],
            selectedValues: _moods,
            onChanged: (next) => setState(() => _moods = next),
            maxSelection: 3,
          ),
          const SizedBox(height: 10),
          Text(
            t.onboarding.howAreYou.multiSelectHint,
            style: TextStyle(
              color: Color(0xFF7A756C),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}