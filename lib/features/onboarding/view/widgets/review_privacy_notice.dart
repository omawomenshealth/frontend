import 'package:flutter/material.dart';

import '../../../../core/theme/oma_theme.dart';

class ReviewPrivacyNotice extends StatelessWidget {
  const ReviewPrivacyNotice({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.favorite_border_rounded,
          color: context.omaTheme.muted,
          size: 16,
        ),
        const SizedBox(width: OmaSpacing.sm),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: OmaText.body(OmaTypeScale.caption, color: context.omaTheme.muted),
          ),
        ),
      ],
    );
  }
}
