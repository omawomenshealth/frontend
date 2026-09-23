import 'package:flutter/material.dart';

import '../../../../core/widgets/index.dart';

class ReviewSummaryRow extends StatelessWidget {
  const ReviewSummaryRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return OmaCard(
      child: OmaCardContent(
        size: OmaCardContentSize.compact,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.start,
                style: OmaText.body(12, color: context.omaTheme.muted),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: OmaText.body(12, weight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
