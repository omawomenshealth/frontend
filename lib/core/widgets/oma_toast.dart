import 'dart:async';

import 'package:flutter/material.dart';

import './oma_theme.dart';

/// "Kaydedildi" bildirimi — web'deki sonner toast'ın Flutter karşılığı.
///
/// Kullanım:
///   OmaToast.show(context, title: 'Kaydedildi',
///       description: 'Profilin güvenle kaydedildi.');
class OmaToast {
  static void show(
    BuildContext context, {
    required String title,
    String? description,
    IconData icon = Icons.check_rounded,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _OmaToastWidget(
        title: title,
        description: description,
        icon: icon,
        duration: duration,
        onDismissed: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );

    overlay.insert(entry);
  }
}

class _OmaToastWidget extends StatefulWidget {
  const _OmaToastWidget({
    required this.title,
    required this.icon,
    required this.duration,
    required this.onDismissed,
    this.description,
  });

  final String title;
  final String? description;
  final IconData icon;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_OmaToastWidget> createState() => _OmaToastWidgetState();
}

class _OmaToastWidgetState extends State<_OmaToastWidget>
    with SingleTickerProviderStateMixin {
  Timer? _dismissTimer;

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
    reverseDuration: const Duration(milliseconds: 220),
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _c,
    curve: Curves.easeOutCubic,
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, -0.35),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

  @override
  void initState() {
    super.initState();
    _c.forward();
    _dismissTimer = Timer(widget.duration, _close);
  }

  Future<void> _close() async {
    if (!mounted) return;
    await _c.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Positioned(
      top: media.padding.top + 12,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: _close,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: OmaColors.card.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: OmaColors.border.withValues(alpha: 0.7),
                      ),
                      boxShadow: OmaShadows.soft,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: OmaColors.plum.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            size: 16,
                            color: OmaColors.plum,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: OmaText.body(
                                  14,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              if (widget.description != null) ...[
                                const SizedBox(height: 3),
                                Text(
                                  widget.description!,
                                  style: OmaText.body(
                                    12,
                                    color: OmaColors.muted,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
