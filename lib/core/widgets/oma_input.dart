import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../views/onboarding/view/widgets/oma_theme.dart';

class OmaInput extends StatelessWidget {
  const OmaInput({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.maxLines = 1,
    this.autofocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixText,
  });

  final TextEditingController? controller;

  final String? hintText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  final int maxLines;

  final bool autofocus;
  final bool readOnly;
  final bool enabled;

  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? suffixText;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(
      Radius.circular(18),
    );

    OutlineInputBorder border(
      Color color, [
      double width = 1,
    ]) {
      return OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(
          color: color,
          width: width,
        ),
      );
    }

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      autofocus: autofocus,
      readOnly: readOnly,
      enabled: enabled,
      onTap: onTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: OmaText.body(
        14,
        color: OmaColors.foreground,
      ),
      cursorColor: OmaColors.primary,
      decoration: InputDecoration(
        filled: true,
        fillColor: OmaColors.card,

        hintText: hintText,
        hintStyle: OmaText.body(
          14,
          color: OmaColors.muted,
        ),

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixText: suffixText,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        enabledBorder: border(
          OmaColors.border,
        ),

        focusedBorder: border(
          OmaColors.primary,
          1.4,
        ),

        disabledBorder: border(
          OmaColors.border.withValues(alpha: 0.5),
        ),

        border: border(
          OmaColors.border,
        ),
      ),
    );
  }
}
