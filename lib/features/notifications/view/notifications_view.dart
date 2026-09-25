import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/oma_theme.dart';
import '../../../core/widgets/oma_tabs.dart';
import '../../../core/widgets/oma_wrap.dart';
import '../../../localization/generated/strings.g.dart';
import '../model/notification_entry.dart';
import '../viewmodel/notification_inbox.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  NotificationEntryType _selected = NotificationEntryType.app;

  @override
  Widget build(BuildContext context) {
    final labels = context.t.notifications.common;
    final inbox = context.watch<NotificationInbox>();

    return Scaffold(
      backgroundColor: context.omaTheme.background,
      body: OmaSurface(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  OmaSpacing.lg,
                  OmaSpacing.md,
                  OmaSpacing.xl,
                  OmaSpacing.none,
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: MaterialLocalizations.of(
                        context,
                      ).backButtonTooltip,
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: context.omaTheme.foreground,
                    ),
                    const SizedBox(width: OmaSpacing.sm),
                    Expanded(
                      child: Text(
                        labels.title,
                        style: OmaText.display(29).copyWith(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  OmaSpacing.xxl,
                  OmaSpacing.md,
                  OmaSpacing.xxl,
                  22,
                ),
                child: Text(
                  labels.subtitle,
                  style: OmaText.body(13, color: context.omaTheme.muted),
                ),
              ),
              Expanded(
                child: OmaTabs<NotificationEntryType>(
                  defaultValue: NotificationEntryType.app,
                  onValueChanged: (value) {
                    if (value != _selected) {
                      setState(() => _selected = value);
                    }
                  },
                  spacing: OmaSpacing.xl,
                  expandContent: true,
                  children: [
                    OmaTabsList<NotificationEntryType>(
                      key: const ValueKey('notifications_tabs_container'),
                      margin: const EdgeInsets.symmetric(
                        horizontal: OmaSpacing.xl,
                      ),
                      children: [
                        _notificationTab(
                          NotificationEntryType.app,
                          labels.appTab,
                          Icons.notifications_none_rounded,
                        ),
                        _notificationTab(
                          NotificationEntryType.log,
                          labels.logTab,
                          Icons.edit_note_rounded,
                        ),
                      ],
                    ),
                    OmaTabsContent<NotificationEntryType>(
                      value: NotificationEntryType.app,
                      child: _notificationContent(
                        NotificationEntryType.app,
                        inbox.entriesFor(NotificationEntryType.app),
                      ),
                    ),
                    OmaTabsContent<NotificationEntryType>(
                      value: NotificationEntryType.log,
                      child: _notificationContent(
                        NotificationEntryType.log,
                        inbox.entriesFor(NotificationEntryType.log),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  OmaTabsTrigger<NotificationEntryType> _notificationTab(
    NotificationEntryType type,
    String label,
    IconData icon,
  ) {
    final selected = _selected == type;
    final accent = type == NotificationEntryType.app
        ? OmaPalette.plum
        : context.omaTheme.primary;
    final color = selected ? accent : context.omaTheme.muted;

    return OmaTabsTrigger<NotificationEntryType>(
      key: ValueKey('notification_tab_${type.name}'),
      value: type,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: OmaSpacing.sm),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: OmaText.label(
                weight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected
                    ? context.omaTheme.foreground
                    : context.omaTheme.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationContent(
    NotificationEntryType type,
    List<NotificationEntry> entries,
  ) {
    final labels = context.t.notifications.common;
    final isApp = type == NotificationEntryType.app;
    final accent = isApp ? OmaPalette.plum : context.omaTheme.primary;

    if (entries.isNotEmpty) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          OmaSpacing.xl,
          OmaSpacing.none,
          OmaSpacing.xl,
          OmaSpacing.xxxl,
        ),
        itemCount: entries.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) => _entryCard(entries[index], accent),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, OmaSpacing.none, 28, 70),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isApp
                    ? Icons.notifications_none_rounded
                    : Icons.edit_note_rounded,
                size: 34,
                color: accent,
              ),
            ),
            const SizedBox(height: OmaSpacing.xl),
            Text(
              isApp ? labels.appEmptyTitle : labels.logEmptyTitle,
              textAlign: TextAlign.center,
              style: OmaText.body(17, weight: FontWeight.w600),
            ),
            const SizedBox(height: 7),
            Text(
              isApp ? labels.appEmptyDescription : labels.logEmptyDescription,
              textAlign: TextAlign.center,
              style: OmaText.body(13, color: context.omaTheme.muted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entryCard(NotificationEntry entry, Color accent) {
    if (entry.type == NotificationEntryType.log &&
        entry.periodDetails != null) {
      return _periodEntryCard(entry, entry.periodDetails!);
    }
    final locale = Localizations.localeOf(context).toString();
    return Container(
      padding: const EdgeInsets.all(OmaSpacing.lg),
      decoration: BoxDecoration(
        color: context.omaTheme.surface,
        borderRadius: BorderRadius.circular(OmaRadius.xl),
        border: Border.all(color: context.omaTheme.border),
        boxShadow: context.omaTheme.softShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              entry.type == NotificationEntryType.app
                  ? Icons.notifications_none_rounded
                  : Icons.check_rounded,
              size: 18,
              color: accent,
            ),
          ),
          const SizedBox(width: OmaSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: OmaText.body(
                    OmaTypeScale.body,
                    weight: FontWeight.w600,
                  ),
                ),
                if (entry.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: OmaSpacing.xs),
                  Text(
                    entry.description!,
                    style: OmaText.body(
                      OmaTypeScale.caption,
                      color: context.omaTheme.muted,
                    ),
                  ),
                ],
                const SizedBox(height: 9),
                Text(
                  DateFormat('d MMM y · HH:mm', locale).format(entry.createdAt),
                  style: OmaText.caption(color: context.omaTheme.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodEntryCard(
    NotificationEntry entry,
    PeriodNotificationDetails details,
  ) {
    final labels = context.t.notifications.common;
    final locale = Localizations.localeOf(context).toString();
    final flow = details.flow == null
        ? null
        : AppStrings.localizeStoredValue(details.flow!);
    final symptoms = details.symptoms
        .map(AppStrings.localizeStoredValue)
        .toList();

    return Container(
      key: const ValueKey('period_notification_card'),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [OmaPalette.periodLight, context.omaTheme.surface],
        ),
        borderRadius: BorderRadius.circular(OmaRadius.xl),
        border: Border.all(
          color: OmaPalette.periodPrimary.withValues(alpha: 0.25),
        ),
        boxShadow: context.omaTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: OmaPalette.periodPrimary.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(OmaRadius.md),
                ),
                child: const Icon(
                  Icons.water_drop_outlined,
                  size: 19,
                  color: OmaPalette.periodPrimary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  labels.periodEntry,
                  style: OmaText.body(
                    11,
                    weight: FontWeight.w700,
                    color: OmaPalette.periodPrimary,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Text(
                DateFormat.Hm(locale).format(entry.createdAt),
                style: OmaText.caption(color: context.omaTheme.muted),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(entry.title, style: OmaText.body(17, weight: FontWeight.w700)),
          const SizedBox(height: OmaSpacing.xxs),
          Text(
            DateFormat.yMMMMd(locale).format(details.date),
            style: OmaText.body(
              OmaTypeScale.caption,
              color: context.omaTheme.muted,
            ),
          ),
          if (flow != null && flow.isNotEmpty) ...[
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: context.omaTheme.surface.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(OmaRadius.md),
                border: Border.all(
                  color: OmaPalette.periodPrimary.withValues(alpha: 0.13),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    labels.periodFlow,
                    style: OmaText.body(
                      OmaTypeScale.caption,
                      color: context.omaTheme.muted,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      flow,
                      textAlign: TextAlign.end,
                      style: OmaText.body(
                        13,
                        weight: FontWeight.w600,
                        color: OmaPalette.periodPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (symptoms.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              labels.periodSymptoms,
              style: OmaText.body(11, color: context.omaTheme.muted),
            ),
            const SizedBox(height: OmaSpacing.sm),
            OmaWrap(
              spacing: 7,
              runSpacing: 7,
              children: [
                for (final symptom in symptoms)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: context.omaTheme.surface,
                      borderRadius: BorderRadius.circular(OmaRadius.full),
                      border: Border.all(
                        color: OmaPalette.periodPrimary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      symptom,
                      style: OmaText.body(
                        11,
                        color: context.omaTheme.foreground,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
