import 'package:flutter/material.dart';

import '../theme/oma_theme.dart';

/// Displays a short contextual message using Oma's semantic callout colors.
class OmaCallout extends StatelessWidget {
  const OmaCallout({super.key, required this.child, this.icon});

  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: oma.callout,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, color: oma.calloutForeground, size: 16),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: DefaultTextStyle(
                style: OmaText.body(12, color: oma.calloutForeground),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
