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
          imagePath: 'assets/images/period.png',
          color: AppColors.periodPrimary,
          bgColor: Color(0xFFC5D89D),
          onTap: onPeriodTap,
        ),
      _QuickAction(
        imagePath: 'assets/images/nutrition.png',
        color: AppColors.warning,
        bgColor: Color(0xFFC5D89D),
        onTap: onNutritionTap,
      ),
      _QuickAction(
        imagePath: 'assets/images/medication.png',
        color: AppColors.medicationPrimary,
        bgColor: Color(0xFFC5D89D),
        onTap: onMedicationTap,
      ),
      _QuickAction(
        imagePath: 'assets/images/mood.png',
        color: AppColors.moodHappy,
        bgColor: Color(0xFFC5D89D),
        onTap: onMoodTap,
      ),
    ];

    return Row(
      children: options.map((option) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
              boxShadow: [
                // 1. Ana, derin alt gölge (koyu ve derin)
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: _isPressed ? 0.3 : 0.2,
                  ), // Daha koyu
                  blurRadius: _isPressed ? 15 : 10, // Daha geniş yayılım
                  offset: _isPressed
                      ? const Offset(0, 5)
                      : const Offset(0, 8), // Daha derin offset
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    widget.option.imagePath,
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
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
  final String imagePath;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _QuickAction({
    required this.imagePath,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });
}
