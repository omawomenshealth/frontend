import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';

/// Emoji tabanlı ruh hali seçici kartı.
class MoodSelectorCard extends StatelessWidget {
  final String? selectedMood;
  final String? selectedEmoji;
  final ValueChanged<MapEntry<String, String>> onMoodSelected;

  const MoodSelectorCard({
    super.key,
    this.selectedMood,
    this.selectedEmoji,
    required this.onMoodSelected,
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
              const Icon(Icons.mood, color: AppColors.moodHappy, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Nasıl hissediyorsun?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              if (selectedEmoji != null)
                Text(selectedEmoji!, style: const TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: AppStrings.moodOptions.entries.map((entry) {
              final isSelected = selectedMood == entry.key;
              return GestureDetector(
                onTap: () => onMoodSelected(entry),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _getMoodColor(entry.key).withValues(alpha: 0.15)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? _getMoodColor(entry.key)
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entry.value, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 4),
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? _getMoodColor(entry.key)
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Mutlu':
        return AppColors.moodHappy;
      case 'Huzurlu':
        return AppColors.moodPeaceful;
      case 'İyi':
      case 'Enerjik':
        return AppColors.moodGood;
      case 'Normal':
        return AppColors.moodNeutral;
      case 'Kötü':
      case 'Üzgün':
        return AppColors.moodSad;
      case 'Sinirli':
        return AppColors.moodAngry;
      case 'Kaygılı':
        return AppColors.moodAnxious;
      case 'Yorgun':
        return AppColors.moodSad;
      default:
        return AppColors.moodNeutral;
    }
  }
}
