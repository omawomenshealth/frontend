import 'package:flutter/material.dart';

/// Sayfa girişlerinde ortak "alttan belirerek yükselme" animasyonu.
///
/// Bir `State`'e eklemek için:
/// ```dart
/// class _MyPageState extends State<MyPage>
///     with SingleTickerProviderStateMixin, RiseAnimationMixin {
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         RiseIn(animation: riseAt(0), child: _Header()),
///         RiseIn(animation: riseAt(0.2), child: _Card()),
///         RiseIn(animation: riseAt(0.3), child: _Footer()),
///       ],
///     );
///   }
/// }
/// ```
///
/// `riseAt(delay)` her çağrıldığında aynı `riseController`'a bağlı yeni bir
/// `CurvedAnimation` döner; `delay` 0-1 arasında, animasyonun ne zaman
/// başlayacağını belirler (0.2 = sürenin %20'si geçtikten sonra başlar).
mixin RiseAnimationMixin<T extends StatefulWidget> on State<T>, TickerProvider {
  /// Tüm sayfalarda tutarlılık için ortak animasyon süresi.
  static const Duration riseDuration = Duration(milliseconds: 900);

  late final AnimationController riseController = AnimationController(
    vsync: this,
    duration: riseDuration,
  )..forward();

  Animation<double> riseAt(double delay) => CurvedAnimation(
        parent: riseController,
        curve: Interval(delay, 1, curve: Curves.easeOutCubic),
      );

  @override
  void dispose() {
    riseController.dispose();
    super.dispose();
  }
}

/// Verilen animasyona göre alttan yukarı belirerek gelen genel amaçlı
/// sarmalayıcı. Genelde [RiseAnimationMixin.riseAt] ile birlikte kullanılır,
/// ama herhangi bir `Animation<double>` (0 → 1) ile de çalışır.
class RiseIn extends StatelessWidget {
  const RiseIn({
    super.key,
    required this.animation,
    required this.child,
    this.offset = 14,
  });

  final Animation<double> animation;
  final Widget child;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, c) => Opacity(
        opacity: animation.value,
        child: Transform.translate(
          offset: Offset(0, offset * (1 - animation.value)),
          child: c,
        ),
      ),
      child: child,
    );
  }
}