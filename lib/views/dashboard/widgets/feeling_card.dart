import 'package:flutter/material.dart';
import '../../../core/constants/color_constants.dart';

/// Dashboard'da 4 eşit yuvarlak parçaya bölünmüş hızlı erişim kartı.
/// Regl girişi, Yeme-İçme, İlaç Takibi, Nasıl Hissediyorsun.
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
    final options = <_QuickAction>[
      if (showPeriod)
        _QuickAction(
          emoji: '🩸',
          label: 'Regl\nGirişi',
          color: AppColors.periodPrimary,
          bgColor: const Color(0xFFFFEBEE),
          onTap: onPeriodTap,
        ),
      _QuickAction(
        emoji: '🍽️',
        label: 'Yeme\nİçme',
        color: AppColors.warning,
        bgColor: const Color(0xFFFFF8E1),
        onTap: onNutritionTap,
      ),
      _QuickAction(
        emoji: '💊',
        label: 'İlaç\nTakibi',
        color: AppColors.medicationPrimary,
        bgColor: const Color(0xFFE0F2F1),
        onTap: onMedicationTap,
      ),
      _QuickAction(
        emoji: '😊',
        label: 'Nasıl\nHissediyor.',
        color: AppColors.moodHappy,
        bgColor: const Color(0xFFFFF3E0),
        onTap: onMoodTap,
      ),
    ];

    return Row(
      children: options.map((option) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _QuickActionCircle(option: option),
          ),
        );
      }).toList(),
    );
  }
}

/// Tek bir yuvarlak aksiyon düğmesi
class _QuickActionCircle extends StatefulWidget {
  final _QuickAction option;

  const _QuickActionCircle({required this.option});

  @override
  State<_QuickActionCircle> createState() => _QuickActionCircleState();
}

class _QuickActionCircleState extends State<_QuickActionCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.option.onTap,
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: widget.option.bgColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.option.color.withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.option.color.withValues(alpha: _isPressed ? 0.25 : 0.12),
                  blurRadius: _isPressed ? 12 : 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.option.emoji,
                  style: const TextStyle(fontSize: 26),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.option.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: widget.option.color,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Hızlı aksiyon veri modeli
class _QuickAction {
  final String emoji;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.emoji,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });
}
