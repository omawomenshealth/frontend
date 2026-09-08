import 'package:flutter/material.dart';

import '../../views/onboarding/view/widgets/oma_theme.dart';


/// Label + field + optional hint.
///
/// Generic form field wrapper used across the Oma design system.
class OmaField extends StatelessWidget {
  const OmaField({
    super.key,
    required this.label,
    required this.child,
    this.hint,
  });

  final String label;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: OmaText.body(
            14,
            weight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        child,
        if (hint != null) ...[
          const SizedBox(height: 8),
          Text(
            hint!,
            style: OmaText.body(
              12,
              color: OmaColors.muted,
            ),
          ),
        ],
      ],
    );
  }
}