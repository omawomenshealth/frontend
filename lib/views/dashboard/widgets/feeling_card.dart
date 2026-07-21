import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';

/// Ana ekrandaki tekrar kullanilabilir hizli kayit aksiyonlari.
class FeelingCard extends StatelessWidget {
  final VoidCallback onPeriodTap;
  final VoidCallback onNutritionTap;
  final VoidCallback onMedicationTap;
  final VoidCallback onMoodTap;
  final bool showPeriod;

  const FeelingCard({
    super.key,
    required this.onPeriodTap,
    required this.onNutritionTap,
    required this.onMedicationTap,
    required this.onMoodTap,
    this.showPeriod = true,
  });

  @override
  Widget build(BuildContext context) {
    final actions = <_QuickAction>[
      if (showPeriod)
        _QuickAction(
          label: AppStrings.period,
          icon: Icons.water_drop_outlined,
          onTap: onPeriodTap,
        ),
      _QuickAction(
        label: AppStrings.nutrition,
        icon: Icons.local_dining_outlined,
        onTap: onNutritionTap,
      ),
      _QuickAction(
        label: AppStrings.medications,
        icon: Icons.medication_outlined,
        onTap: onMedicationTap,
      ),
      _QuickAction(
        label: AppStrings.mood,
        icon: Icons.mood_outlined,
        onTap: onMoodTap,
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < actions.length; index++) ...[
          Expanded(child: _QuickActionButton(action: actions[index])),
          if (index != actions.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final _QuickAction action;

  const _QuickActionButton({required this.action});

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.action.label,
      child: GestureDetector(
        onTap: widget.action.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1,
          duration: const Duration(milliseconds: 130),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 130),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _pressed ? AppColors.primaryLight : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryDark, width: 1),
                ),
                child: Icon(
                  widget.action.icon,
                  color: AppColors.primaryDark,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.action.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}
