import 'package:flutter/material.dart';
import '../../../core/theme/oma_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/period_log_model.dart';

/// İlaç / Takviye checklist kartı.
class MedicationChecklistCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<MedicationEntry> items;
  final ValueChanged<int> onToggle;
  final String? emptyMessage;

  const MedicationChecklistCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
    required this.onToggle,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.omaTheme;
    return Container(
      padding: const EdgeInsets.all(OmaSpacing.lg),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(OmaRadius.lg),
        boxShadow: theme.subtleShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: OmaSpacing.sm),
              Text(
                title,
                style: TextStyle(
                  fontSize: OmaTypeScale.bodyLarge,
                  fontWeight: FontWeight.w600,
                  color: theme.foreground,
                ),
              ),
              const Spacer(),
              // Tamamlanan sayısı
              if (items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: OmaSpacing.sm,
                    vertical: OmaSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(OmaRadius.sm),
                  ),
                  child: Text(
                    '${items.where((e) => e.taken).length}/${items.length}',
                    style: TextStyle(
                      fontSize: OmaTypeScale.caption,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),
          if (items.isEmpty) ...[
            const SizedBox(height: OmaSpacing.md),
            Text(
              emptyMessage ?? AppStrings.emptyMedicationList,
              style: TextStyle(fontSize: 13, color: theme.muted),
            ),
          ] else ...[
            const SizedBox(height: OmaSpacing.md),
            ...List.generate(items.length, (index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: GestureDetector(
                  onTap: () => onToggle(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: OmaSpacing.md,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: item.taken
                          ? color.withValues(alpha: 0.08)
                          : theme.background,
                      borderRadius: BorderRadius.circular(OmaRadius.sm),
                      border: Border.all(
                        color: item.taken
                            ? color.withValues(alpha: 0.3)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Checkbox animasyonlu
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: item.taken ? color : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: item.taken ? color : theme.muted,
                              width: 1.5,
                            ),
                          ),
                          child: item.taken
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: OmaPalette.onMedia,
                                )
                              : null,
                        ),
                        const SizedBox(width: OmaSpacing.md),

                        // İlaç/Takviye adı
                        Expanded(
                          child: Text(
                            AppStrings.localizeStoredValue(item.displayName),
                            style: TextStyle(
                              fontSize: OmaTypeScale.body,
                              fontWeight: FontWeight.w500,
                              color: item.taken
                                  ? theme.muted
                                  : theme.foreground,
                              decoration: item.taken
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),

                        // Zaman ve mide durumu
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item.time,
                              style: TextStyle(
                                fontSize: 11,
                                color: color.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              item.stomachState,
                              style: TextStyle(
                                fontSize: OmaTypeScale.micro,
                                color: theme.muted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
