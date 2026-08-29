import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              // Tamamlanan sayısı
              if (items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${items.where((e) => e.taken).length}/${items.length}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),
          if (items.isEmpty) ...[
            const SizedBox(height: 12),
            Text(
              emptyMessage ?? AppStrings.emptyMedicationList,
              style: const TextStyle(fontSize: 13, color: AppColors.textHint),
            ),
          ] else ...[
            const SizedBox(height: 12),
            ...List.generate(items.length, (index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: GestureDetector(
                  onTap: () => onToggle(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: item.taken
                          ? color.withValues(alpha: 0.08)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(10),
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
                              color: item.taken ? color : AppColors.textHint,
                              width: 1.5,
                            ),
                          ),
                          child: item.taken
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),

                        // İlaç/Takviye adı
                        Expanded(
                          child: Text(
                            AppStrings.localizeStoredValue(item.displayName),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: item.taken
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
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
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textHint,
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
