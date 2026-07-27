import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';

/// Ana ekrandaki tekrar kullanilabilir hizli kayit aksiyonlari.
class FeelingCard extends StatelessWidget {
  final VoidCallback onPeriodTap;
  final VoidCallback onNutritionTap;
  final VoidCallback onSymptomTap;
  final VoidCallback onMoodTap;
  final bool showPeriod;

  const FeelingCard({
    super.key,
    required this.onPeriodTap,
    required this.onNutritionTap,
    required this.onSymptomTap,
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
          foreground: AppColors.periodPrimary,
          background: AppColors.periodLight,
          onTap: onPeriodTap,
        ),
      _QuickAction(
        label: AppStrings.symptom,
        icon: Icons.add_rounded,
        foreground: AppColors.periodFlow,
        background: const Color(0xFFF4E4DE),
        onTap: onSymptomTap,
      ),
      _QuickAction(
        label: AppStrings.mood,
        icon: Icons.mood_outlined,
        foreground: AppColors.secondaryDark,
        background: AppColors.secondaryLight,
        onTap: onMoodTap,
      ),
      _QuickAction(
        label: AppStrings.nutrition,
        icon: Icons.bolt_outlined,
        foreground: AppColors.primaryDark,
        background: const Color(0xFFE6EEE0),
        onTap: onNutritionTap,
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
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _pressed
                      ? Color.lerp(
                          widget.action.background,
                          widget.action.foreground,
                          0.08,
                        )
                      : widget.action.background,
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Icon(
                  widget.action.icon,
                  color: widget.action.foreground,
                  size: 22,
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
                  fontSize: 10.5,
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
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.foreground,
    required this.background,
    required this.onTap,
  });
}
