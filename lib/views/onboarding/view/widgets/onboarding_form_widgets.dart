import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/color_constants.dart';

class OnboardingFieldLabel extends StatelessWidget {
  final String label;
  final TextStyle? style;

  const OnboardingFieldLabel(this.label, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style:
          style ??
          const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
    );
  }
}

class OnboardingSectionHeader extends StatelessWidget {
  final String label;

  const OnboardingSectionHeader({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingFieldLabel(label),
        const SizedBox(height: 7),
      ],
    );
  }
}

class OnboardingInputSection extends StatelessWidget {
  final String label;
  final Widget child;
  final double maxWidth;
  final double height;
  final String? helperText;
  final CrossAxisAlignment crossAxisAlignment;
  final TextStyle? labelStyle;
  final TextStyle? helperStyle;

  const OnboardingInputSection({
    super.key,
    required this.label,
    required this.child,
    this.maxWidth = 310,
    this.height = 54,
    this.helperText,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.labelStyle,
    this.helperStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        OnboardingFieldLabel(label, style: labelStyle),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SizedBox(height: height, child: child),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Text(
                helperText!,
                style:
                    helperStyle ??
                    const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.35,
                    ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

InputDecoration onboardingInputDecoration({
  required String hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Color(0xFF9A958A)),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFE3DFD7)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFE3DFD7)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF78904F), width: 1.5),
    ),
  );
}

class OnboardingYesNoSelector extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const OnboardingYesNoSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ChoiceChip(
            label: Center(child: Text(AppStrings.yes)),
            selected: value,
            selectedColor: AppColors.primary.withValues(alpha: 0.14),
            onSelected: (_) => onChanged(true),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: ChoiceChip(
            label: Center(child: Text(AppStrings.no)),
            selected: !value,
            selectedColor: AppColors.primary.withValues(alpha: 0.14),
            onSelected: (_) => onChanged(false),
          ),
        ),
      ],
    );
  }
}

List<String> uniqueOnboardingLabels(Iterable<String> values) {
  final result = <String>[];
  final seen = <String>{};
  for (final raw in values) {
    final value = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (value.isEmpty) continue;
    final normalized = value.replaceAll(RegExp('[İIı]'), 'i').toLowerCase();
    if (seen.add(normalized)) result.add(value);
  }
  return result;
}

