import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';

/// Ana ekrandaki tekrar kullanilabilir hizli kayit aksiyonlari.
class FeelingCard extends StatelessWidget {
  final VoidCallback onPeriodTap;
  final VoidCallback onNutritionTap;
  final VoidCallback onSymptomTap;
  final VoidCallback onMoodTap;
  final VoidCallback? onMedicationTap;
  final VoidCallback? onSkincareTap;
  final bool showPeriod;
  final Color themeColor;

  const FeelingCard({
    super.key,
    required this.onPeriodTap,
    required this.onNutritionTap,
    required this.onSymptomTap,
    required this.onMoodTap,
    this.onMedicationTap,
    this.onSkincareTap,
    this.showPeriod = true,
    this.themeColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final actionBackground =
        Color.lerp(AppColors.surface, themeColor, 0.15) ?? AppColors.surface;
    final actions = <_QuickAction>[
      if (showPeriod)
        _QuickAction(
          label: AppStrings.period,
          icon: Icons.water_drop_outlined,
          foreground: themeColor,
          background: actionBackground,
          onTap: onPeriodTap,
        ),
      _QuickAction(
        label: AppStrings.nutrition,
        icon: Icons.restaurant_menu_rounded,
        foreground: themeColor,
        background: actionBackground,
        onTap: onNutritionTap,
      ),
      _QuickAction(
        label: AppStrings.symptom,
        icon: Icons.medical_information_outlined,
        foreground: themeColor,
        background: actionBackground,
        onTap: onSymptomTap,
      ),
      _QuickAction(
        label: AppStrings.mood,
        icon: Icons.mood_outlined,
        foreground: themeColor,
        background: actionBackground,
        onTap: onMoodTap,
      ),
      if (onMedicationTap != null)
        _QuickAction(
          label: AppStrings.medicationAndSupplement,
          icon: Icons.medication_outlined,
          foreground: themeColor,
          background: actionBackground,
          onTap: onMedicationTap!,
        ),
      if (onSkincareTap != null)
        _QuickAction(
          label: AppStrings.skincare,
          icon: Icons.spa_outlined,
          foreground: themeColor,
          background: actionBackground,
          onTap: onSkincareTap!,
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final visualSize = (constraints.maxWidth / actions.length - 6).clamp(
          48.0,
          64.0,
        );
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final action in actions)
              Expanded(
                child: _QuickActionButton(
                  action: action,
                  visualSize: visualSize,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final _QuickAction action;
  final double visualSize;

  const _QuickActionButton({required this.action, required this.visualSize});

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
                width: widget.visualSize,
                height: widget.visualSize,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
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
