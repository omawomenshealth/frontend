import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/color_constants.dart';
import '../onboarding_typography.dart';

class OnboardingTextField extends StatelessWidget {
  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? suffixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  const OnboardingTextField({
    super.key,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.suffixText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextField(
        key: fieldKey,
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          suffixText: suffixText,
          hintStyle: OnboardingTypography.input.copyWith(
            color: AppColors.textHint,
          ),
          labelStyle: OnboardingTypography.label.copyWith(
            color: AppColors.textSecondary,
          ),
          suffixStyle: OnboardingTypography.control.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          // ...
        ),
        style: OnboardingTypography.input.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}