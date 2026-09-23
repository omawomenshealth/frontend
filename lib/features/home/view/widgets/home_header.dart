import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_time.dart';
import '../../../../core/widgets/oma_button.dart';
import '../../../../core/theme/oma_theme.dart';
import '../../../../localization/generated/strings.g.dart';

/// Home ekranının üst bölümü:
/// sol: selamlama + kullanıcı adı
/// orta: seçili tarih
/// sağ: takvim + bildirim aksiyonları
///
/// ViewModel'e bağımlı değildir; yalnızca ihtiyaç duyduğu değerleri alır.
class HomeHeader extends StatelessWidget {
  final String? userName;
  final DateTime selectedDate;
  final Color accent;
  final VoidCallback onCalendarTap;
  final VoidCallback onNotificationTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.selectedDate,
    required this.accent,
    required this.onCalendarTap,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t.home;
    final theme = context.omaTheme;
    final locale = Localizations.localeOf(context).toString();

    final month = DateFormat.MMMM(locale).format(selectedDate);

    final greeting = switch (AppTime.now.hour) {
      < 12 => '${t.common.header.greeting.morning},',
      < 18 => '${t.common.header.greeting.afternoon},',
      _ => '${t.common.header.greeting.evening},',
    };

    final trimmedName = userName?.trim() ?? '';
    final displayName = trimmedName.isEmpty
        ? t.common.header.greeting.nameFallback
        : trimmedName;

    return SizedBox(
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sol: Greeting + kullanıcı adı
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              // Sağdaki aksiyon alanına taşmasını engeller.
              padding: const EdgeInsets.only(right: 190),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: OmaText.body(
                      11,
                      weight: FontWeight.w700,
                      color: theme.muted,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    displayName,
                    key: const ValueKey('home_header_name'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: OmaText.display(
                      34,
                      color: theme.foreground,
                    ).copyWith(fontWeight: FontWeight.w500, height: 1.02),
                  ),
                ],
              ),
            ),
          ),

          // Orta: Tarih
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${selectedDate.day}',
                  style: OmaText.display(
                    26,
                    color: theme.foreground,
                  ).copyWith(fontWeight: FontWeight.w600, height: 1),
                ),
                const SizedBox(width: 5),
                Text(
                  month,
                  style: OmaText.caption(
                    color: theme.muted,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Sağ: Aksiyon butonları
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OmaIconButton(
                  key: const ValueKey('home_calendar_button'),
                  icon: Icons.calendar_month_outlined,
                  onPressed: onCalendarTap,
                  semanticLabel: t.common.header.date.calendar,
                  foregroundColor: accent,
                  backgroundColor: theme.backgroundAlt,
                  borderColor: accent.withValues(alpha: 0.34),
                ),
                const SizedBox(width: OmaSpacing.sm),
                OmaIconButton(
                  key: const ValueKey('home_notification_button'),
                  icon: Icons.notifications_none_rounded,
                  onPressed: onNotificationTap,
                  semanticLabel: context.t.notifications.common.title,
                  foregroundColor: accent,
                  backgroundColor: theme.backgroundAlt,
                  borderColor: accent.withValues(alpha: 0.34),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
