import 'package:flutter/material.dart';

import '../theme/oma_theme.dart';

/// Seçilebilir yuvarlak etiket.
class OmaChip extends StatelessWidget {
  const OmaChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.showCheck = true,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    final oma = context.omaTheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? oma.primarySoft : oma.surface,
          border: Border.all(color: selected ? oma.primary : oma.border),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCheck && selected) ...[
              Icon(Icons.check, size: 14, color: oma.primary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: OmaText.body(
                14,
                weight: selected ? FontWeight.w500 : FontWeight.w400,
                color: selected ? oma.primary : oma.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OmaChipWrap extends StatelessWidget {
  const OmaChipWrap({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 8, runSpacing: 8, children: children);
  }
}
