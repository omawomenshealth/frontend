import 'package:flutter/material.dart';

import 'oma_theme.dart';


class OmaDialog extends StatelessWidget {
  const OmaDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.actions,
  });

  final IconData icon;
  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: OmaColors.card,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: OmaColors.border),
          boxShadow: OmaShadows.soft,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: OmaColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: OmaText.display(18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            content,
            const SizedBox(height: 18),
            ...actions,
          ],
        ),
      ),
    );
  }
}