import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/widgets/index.dart';
import '../../../../localization/generated/strings.g.dart';
import '../../formatters/onboarding_date_slash_formatter.dart';
import '../../viewmodel/onboarding_view_model.dart';
import '../widgets/index.dart';
import '../widgets/oma_theme.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({
    super.key,
    required this.vm,
    required this.birthDateController,
    required this.onPickBirthDate,
    required this.onBirthDateChanged,
  });

  final OnboardingViewModel vm;
  final TextEditingController birthDateController;
  final VoidCallback onPickBirthDate;
  final ValueChanged<String> onBirthDateChanged;

  @override
  Widget build(BuildContext context) {
    final introduction = context.t.onboarding.introduction;

    return OnboardingCard(
      label: introduction.title,
      children: [
        _NameField(
          onChanged: vm.setUserName,
        ),
        _BirthDateField(
          controller: birthDateController,
          onChanged: onBirthDateChanged,
          onPickBirthDate: onPickBirthDate,
        ),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final introduction = context.t.onboarding.introduction;

    return OmaField(
      label: introduction.name,
      child: OmaInput(
        hintText: introduction.nameHint,
        textCapitalization: TextCapitalization.words,
        onChanged: onChanged,
      ),
    );
  }
}

class _BirthDateField extends StatelessWidget {
  const _BirthDateField({
    required this.controller,
    required this.onChanged,
    required this.onPickBirthDate,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onPickBirthDate;

  @override
  Widget build(BuildContext context) {
    final introduction = context.t.onboarding.introduction;

    return OmaField(
      label: introduction.birthDate,
      hint: introduction.birthDateHelper,
      child: OmaInput(
        controller: controller,
        hintText: introduction.birthDateHint,
        keyboardType: TextInputType.datetime,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'[0-9/]'),
          ),
          LengthLimitingTextInputFormatter(10),
          const OnboardingDateSlashFormatter(),
        ],
        onChanged: onChanged,
        suffixIcon: IconButton(
          tooltip: introduction.chooseFromCalendar,
          onPressed: onPickBirthDate,
          icon: const Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: OmaColors.muted,
          ),
        ),
      ),
    );
  }
}
