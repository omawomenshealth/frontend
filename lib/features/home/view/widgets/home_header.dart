import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_time.dart';
import '../../../../core/widgets/oma_button.dart';
import '../../../../core/widgets/oma_theme.dart';
import '../../../../localization/generated/strings.g.dart';

/// Home ekranının üst bölümü:
/// selamlama + kullanıcı adı, seçili tarih ve takvim kısayolu.
///
/// ViewModel'e bağımlı değildir; yalnızca ihtiyaç duyduğu değerleri alır.
class HomeHeader extends StatelessWidget {
  final String? userName;
  final DateTime selectedDate;
  final Color accent;
  final VoidCallback onCalendarTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.selectedDate,
    required this.accent,
    required this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t.home;
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

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: OmaText.body(
                  11,
                  weight: FontWeight.w700,
                  color: OmaColors.muted,
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
                  color: OmaColors.foreground,
                ).copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.02,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${selectedDate.day}',
                style: OmaText.display(
                  26,
                  color: OmaColors.foreground,
                ).copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                month,
                style: OmaText.caption(
                  color: OmaColors.muted,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 19),
        OmaIconButton(
          key: const ValueKey('home_calendar_button'),
          icon: Icons.calendar_month_outlined,
          onPressed: onCalendarTap,
          semanticLabel: t.common.header.date.calendar,
          foregroundColor: accent,
          backgroundColor: OmaColors.backgroundAlt,
          borderColor: accent.withValues(alpha: 0.34),
        ),
      ],
    );
  }
}