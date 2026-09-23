import 'package:flutter/material.dart';

import '../../../../core/theme/oma_theme.dart';
import '../../../../localization/generated/strings.g.dart';

/// Home ekranındaki hızlı kayıt bölümü.
///
/// Nutrition, symptom, mood, medication ve skincare kayıtlarına
/// erişim sağlar. Sheet açma ve kayıt işlemleri parent tarafından yönetilir.
class QuickLogs extends StatelessWidget {
  final Color accent;
  final VoidCallback onPeriodTap;
  final VoidCallback onNutritionTap;
  final VoidCallback onSymptomTap;
  final VoidCallback onMoodTap;
  final VoidCallback onMedicationTap;
  final VoidCallback onSkincareTap;

  const QuickLogs({
    super.key,
    required this.accent,
    required this.onPeriodTap,
    required this.onNutritionTap,
    required this.onSymptomTap,
    required this.onMoodTap,
    required this.onMedicationTap,
    required this.onSkincareTap,
  });

  @override
  Widget build(BuildContext context) {
    final strings = context.t.home;
    final theme = context.omaTheme;

    final logBackground = Color.lerp(theme.surface, accent, 0.15)!;

    final logs = [
      _QuickLog(
        label: strings.common.quickLogs.buttons.period,
        icon: Icons.water_drop_outlined,
        foreground: accent,
        background: logBackground,
        onTap: onPeriodTap,
      ),
      _QuickLog(
        label: strings.common.quickLogs.buttons.nutrition,
        icon: Icons.restaurant_menu_rounded,
        foreground: accent,
        background: logBackground,
        onTap: onNutritionTap,
      ),
      _QuickLog(
        label: strings.common.quickLogs.buttons.symptom,
        icon: Icons.medical_information_outlined,
        foreground: accent,
        background: logBackground,
        onTap: onSymptomTap,
      ),
      _QuickLog(
        label: strings.common.quickLogs.buttons.mood,
        icon: Icons.mood_outlined,
        foreground: accent,
        background: logBackground,
        onTap: onMoodTap,
      ),
      _QuickLog(
        label: strings.common.quickLogs.buttons.medication,
        icon: Icons.medication_outlined,
        foreground: accent,
        background: logBackground,
        onTap: onMedicationTap,
      ),
      _QuickLog(
        label: strings.common.quickLogs.buttons.skincare,
        icon: Icons.spa_outlined,
        foreground: accent,
        background: logBackground,
        onTap: onSkincareTap,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: strings.common.quickLogs.title,
          caption: strings.common.quickLogs.caption,
        ),
        const SizedBox(height: OmaSpacing.lg),
        LayoutBuilder(
          builder: (context, constraints) {
            final visualSize = (constraints.maxWidth / logs.length - 6).clamp(
              48.0,
              64.0,
            );

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final log in logs)
                  Expanded(
                    child: _QuickLogButton(log: log, visualSize: visualSize),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String caption;

  const _SectionHeader({required this.title, required this.caption});

  @override
  Widget build(BuildContext context) {
    final theme = context.omaTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: Text(
            title,
            style: OmaText.display(
              25,
              style: FontStyle.normal,
              color: theme.foreground,
            ).copyWith(fontWeight: FontWeight.w500, letterSpacing: -0.4),
          ),
        ),
        Text(
          caption,
          style: OmaText.caption(
            color: theme.muted,
            weight: FontWeight.w500,
          ).copyWith(fontSize: 10.5),
        ),
      ],
    );
  }
}

class _QuickLogButton extends StatefulWidget {
  final _QuickLog log;
  final double visualSize;

  const _QuickLogButton({required this.log, required this.visualSize});

  @override
  State<_QuickLogButton> createState() => _QuickLogButtonState();
}

class _QuickLogButtonState extends State<_QuickLogButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.log.label,
      child: GestureDetector(
        onTap: widget.log.onTap,
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
                          widget.log.background,
                          widget.log.foreground,
                          0.08,
                        )
                      : widget.log.background,
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Icon(
                  widget.log.icon,
                  color: widget.log.foreground,
                  size: 22,
                ),
              ),
              const SizedBox(height: OmaSpacing.sm),
              Text(
                widget.log.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: OmaText.body(
                  9.5,
                  weight: FontWeight.w600,
                  color: context.omaTheme.foreground,
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

class _QuickLog {
  final String label;
  final IconData icon;
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  const _QuickLog({
    required this.label,
    required this.icon,
    required this.foreground,
    required this.background,
    required this.onTap,
  });
}
