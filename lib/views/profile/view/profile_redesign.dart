part of 'profile_view.dart';

/// Lovable profil tasarımını, uygulamanın mevcut profil mekanikleriyle birleştirir.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  static const _mechanics = _ProfileMechanics();

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return Consumer2<ProfileViewModel, DashboardViewModel>(
      builder: (context, profile, dashboard, _) {
        if (profile.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final calculator = dashboard.periodCalculator;
        final phase = calculator?.currentPhase ?? CyclePhase.follicular;
        final accent = _phaseColor(phase);
        final cycleDay = _cycleDay(calculator, AppTime.now);

        return Scaffold(
          backgroundColor: Color.lerp(
            AppColors.scaffoldBackground,
            accent,
            0.035,
          ),
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProfileHero(
                    profile: profile,
                    calculator: calculator,
                    cycleDay: cycleDay,
                    accent: accent,
                    onEditProfile: () =>
                        _mechanics._showBasicInfoSheet(context, profile),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 116),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PremiumProfileCard(accent: accent),
                        const SizedBox(height: 30),
                        _SectionTitle(text: AppStrings.profileCurrentMode),
                        const SizedBox(height: 12),
                        _ProfileModeSelector(accent: accent),
                        const SizedBox(height: 30),
                        _SectionTitle(
                          text: AppStrings.profileCycleTrack,
                          trailing: _RoundIconButton(
                            icon: Icons.tune_rounded,
                            accent: accent,
                            tooltip: AppStrings.womenHealth,
                            compact: true,
                            onTap: () => _mechanics._showWomenHealthSheet(
                              context,
                              profile,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _CycleOverviewCard(
                          profile: profile,
                          dashboard: dashboard,
                          accent: accent,
                          onEdit: () => _mechanics._showWomenHealthSheet(
                            context,
                            profile,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _SectionTitle(
                          text: AppStrings.laboratoryResults,
                          trailing: _RoundIconButton(
                            icon: Icons.edit_outlined,
                            accent: accent,
                            tooltip: AppStrings.editLaboratoryResults,
                            compact: true,
                            onTap: () => _mechanics._showLabResultsSheet(
                              context,
                              profile,
                              accent: accent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _LabResultsCard(
                          settings: profile.settings,
                          accent: accent,
                          onEdit: () => _mechanics._showLabResultsSheet(
                            context,
                            profile,
                            accent: accent,
                          ),
                        ),
                        const SizedBox(height: 30),
                        _SectionTitle(text: AppStrings.profileSymptomPatterns),
                        const SizedBox(height: 12),
                        _PatternCard(
                          insights: dashboard.personalInsights,
                          accent: accent,
                        ),
                        const SizedBox(height: 30),
                        _SectionTitle(text: AppStrings.account),
                        const SizedBox(height: 12),
                        _AccountCard(
                          profile: profile,
                          accent: accent,
                          onEditProfile: () =>
                              _mechanics._showBasicInfoSheet(context, profile),
                          onEditMedication: () =>
                              _mechanics._showMedicationSheet(context, profile),
                          onDoctorReport: () => _openDoctorReport(context),
                          onDreams: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DreamsView(),
                            ),
                          ),
                          onPrivacy: () =>
                              Navigator.of(context).pushNamed('/privacy'),
                          onHelp: () => _showHelpDialog(context),
                        ),
                        const SizedBox(height: 16),
                        _mechanics._buildSyncCard(context, profile),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Color _phaseColor(CyclePhase phase) {
    return switch (phase) {
      CyclePhase.menstrual => AppColors.periodPrimary,
      CyclePhase.follicular => AppColors.primary,
      CyclePhase.ovulation => AppColors.ovulation,
      CyclePhase.luteal => AppColors.lutealDark,
    };
  }

  static int _cycleDay(PeriodCalculator? calculator, DateTime date) {
    if (calculator == null || calculator.cycleLength <= 0) return 1;
    final difference = date.dateOnly
        .difference(calculator.lastPeriodDate.dateOnly)
        .inDays;
    final normalized =
        ((difference % calculator.cycleLength) + calculator.cycleLength) %
        calculator.cycleLength;
    return normalized + 1;
  }

  Future<void> _showHelpDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.favorite_outline_rounded,
          color: AppColors.primary,
        ),
        title: Text(AppStrings.profileSupportTitle),
        content: Text(AppStrings.profileSupportDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(AppStrings.gotIt),
          ),
        ],
      ),
    );
  }

  Future<void> _openDoctorReport(BuildContext context) async {
    final premium = context.read<PremiumPurchaseService>();
    await premium.refreshEntitlement();
    if (!context.mounted) return;
    if (!premium.isPremium) {
      await showPremiumPaywall(
        context,
        title: AppStrings.premiumRequired,
        description: AppStrings.doctorReportPremiumDescription,
      );
      if (!context.mounted || !premium.isPremium) return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DoctorReportView()),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final ProfileViewModel profile;
  final PeriodCalculator? calculator;
  final int cycleDay;
  final Color accent;
  final VoidCallback onEditProfile;

  const _ProfileHero({
    required this.profile,
    required this.calculator,
    required this.cycleDay,
    required this.accent,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final name = profile.settings.userName.isNotEmpty
        ? profile.settings.userName
        : AppStrings.user;
    final phaseLine = calculator == null
        ? AppStrings.completeCycleDetails
        : '${AppStrings.cycleDayLabel} $cycleDay · '
              '${calculator!.currentPhaseName}';

    return Container(
      width: double.infinity,
      height: 318,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.lerp(accent, Colors.white, 0.82)!,
            Color.lerp(accent, AppColors.scaffoldBackground, 0.90)!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(34)),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -32,
            top: 118,
            child: _DecorativeCircle(
              color: accent.withValues(alpha: 0.05),
              size: 102,
            ),
          ),
          Positioned(
            right: -22,
            top: 66,
            child: _DecorativeCircle(
              color: accent.withValues(alpha: 0.07),
              size: 76,
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 16,
            child: Row(
              children: [
                _RoundIconButton(
                  icon: Icons.settings_outlined,
                  accent: accent,
                  tooltip: AppStrings.basicInformation,
                  onTap: onEditProfile,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 29,
                            height: 1,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          phaseLine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Karla',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color.lerp(
                              AppColors.textSecondary,
                              accent,
                              0.32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 46, height: 46),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -1,
            child: Semantics(
              image: true,
              label: AppStrings.profileCharactersSemantics,
              child: Image.asset(
                'assets/images/oma-profile-characters.png',
                height: 228,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _DecorativeCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String tooltip;
  final VoidCallback onTap;
  final bool compact;

  const _RoundIconButton({
    required this.icon,
    required this.accent,
    required this.tooltip,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 34.0 : 43.0;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: compact ? 0.72 : 0.84),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, size: compact ? 17 : 20, color: accent),
          ),
        ),
      ),
    );
  }
}

class _PremiumProfileCard extends StatelessWidget {
  final Color accent;

  const _PremiumProfileCard({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(25),
        onTap: () => showPremiumPaywall(context),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(accent, Colors.white, 0.20)!,
                Color.lerp(accent, AppColors.primaryDark, 0.15)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.18),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.profilePremiumTitle,
                      style: const TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppStrings.profilePremiumDescription,
                      style: TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 12,
                        height: 1.25,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.86),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;

  const _SectionTitle({required this.text, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 24,
              height: 1,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

class _ProfileModeSelector extends StatefulWidget {
  final Color accent;

  const _ProfileModeSelector({required this.accent});

  @override
  State<_ProfileModeSelector> createState() => _ProfileModeSelectorState();
}

class _ProfileModeSelectorState extends State<_ProfileModeSelector> {
  @override
  Widget build(BuildContext context) {
    final selectedMode = context
        .watch<ProfileViewModel>()
        .settings
        .trackingMode;
    final options = [
      (
        mode: TrackingMode.cycle,
        icon: Icons.local_florist_outlined,
        title: AppStrings.modeTrackCycle,
        subtitle: AppStrings.modeTrackCycleSubtitle,
        enabled: true,
      ),
      (
        mode: TrackingMode.tryingToConceive,
        icon: Icons.favorite_border_rounded,
        title: AppStrings.modeGetPregnant,
        subtitle: AppStrings.modeGetPregnantSubtitle,
        enabled: false,
      ),
      (
        mode: TrackingMode.pregnant,
        icon: Icons.child_friendly_outlined,
        title: AppStrings.modePregnancy,
        subtitle: AppStrings.modePregnancySubtitle,
        enabled: false,
      ),
    ];
    final selected = options.indexWhere(
      (option) => option.mode == selectedMode,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SurfaceCard(
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < options.length; index++)
                  Expanded(
                    child: Semantics(
                      button: true,
                      enabled: options[index].enabled,
                      selected: selected == index,
                      label: options[index].title,
                      child: Opacity(
                        opacity: options[index].enabled ? 1 : 0.42,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            key: ValueKey(
                              'profile_mode_${options[index].mode.name}',
                            ),
                            borderRadius: BorderRadius.circular(18),
                            onTap: options[index].enabled
                                ? () => _selectMode(
                                    context,
                                    options[index].mode,
                                    options[index].title,
                                  )
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOut,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                color: selected == index
                                    ? widget.accent.withValues(alpha: 0.11)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    options[index].icon,
                                    size: 22,
                                    color: selected == index
                                        ? widget.accent
                                        : AppColors.textHint,
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    options[index].title,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: 'Karla',
                                      fontSize: 11,
                                      height: 1.1,
                                      fontWeight: FontWeight.w700,
                                      color: selected == index
                                          ? widget.accent
                                          : AppColors.textSecondary,
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 9),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            options[selected < 0 ? 0 : selected].subtitle,
            style: const TextStyle(
              fontFamily: 'Karla',
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectMode(
    BuildContext context,
    TrackingMode mode,
    String title,
  ) async {
    final profile = context.read<ProfileViewModel>();
    if (profile.settings.trackingMode == mode) return;

    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            key: const ValueKey('tracking_mode_confirmation'),
            icon: Icon(switch (mode) {
              TrackingMode.cycle => Icons.local_florist_outlined,
              TrackingMode.tryingToConceive => Icons.favorite_border_rounded,
              TrackingMode.pregnant => Icons.child_friendly_outlined,
            }, color: widget.accent),
            title: Text(AppStrings.modeChangeConfirmationTitle),
            content: Text(AppStrings.modeChangeConfirmationBody(title)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(AppStrings.cancel),
              ),
              FilledButton(
                key: const ValueKey('tracking_mode_confirm'),
                onPressed: () => Navigator.pop(dialogContext, true),
                style: FilledButton.styleFrom(backgroundColor: widget.accent),
                child: Text(AppStrings.changeModeAction),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed || !context.mounted) return;

    final saved = await profile.setTrackingMode(mode);
    if (!context.mounted) return;
    if (!saved) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.modeChangeFailed)));
      return;
    }
    await context.read<DashboardViewModel>().loadData();
    if (!context.mounted) return;
    await context.read<CalendarViewModel>().loadData();
  }
}

class _CycleOverviewCard extends StatelessWidget {
  final ProfileViewModel profile;
  final DashboardViewModel dashboard;
  final Color accent;
  final VoidCallback onEdit;

  const _CycleOverviewCard({
    required this.profile,
    required this.dashboard,
    required this.accent,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final insights = dashboard.cycleInsights;
    final cycleValue = insights?.previousCycleLength == null
        ? AppStrings.waitingForData
        : AppStrings.dayCount(insights!.previousCycleLength!);
    final periodValue = insights == null
        ? AppStrings.dayCount(profile.settings.averagePeriodLength)
        : AppStrings.dayCount(insights.previousPeriodLength);
    final variationValue =
        insights?.variationMin == null || insights?.variationMax == null
        ? AppStrings.waitingForData
        : '${insights!.variationMin}–${insights.variationMax} '
              '${AppStrings.daysUnit}';

    return _SurfaceCard(
      child: Column(
        children: [
          _CycleMetric(
            icon: Icons.autorenew_rounded,
            label: AppStrings.previousCycleLength,
            value: cycleValue,
            badge: _cycleStatusLabel(insights?.cycleStatus),
            badgePositive: insights?.cycleStatus == CycleStatus.normal,
            accent: accent,
          ),
          const _SoftDivider(),
          _CycleMetric(
            icon: Icons.water_drop_outlined,
            label: AppStrings.previousPeriodLength,
            value: periodValue,
            badge: _cycleStatusLabel(insights?.periodStatus),
            badgePositive: insights?.periodStatus == CycleStatus.normal,
            accent: accent,
          ),
          const _SoftDivider(),
          _CycleMetric(
            icon: Icons.show_chart_rounded,
            label: AppStrings.cycleLengthVariation,
            value: variationValue,
            badge: _regularityLabel(insights?.regularity),
            badgePositive: insights?.regularity == CycleRegularity.regular,
            accent: accent,
          ),
          const _SoftDivider(),
          _AccountRow(
            icon: Icons.tune_rounded,
            title: AppStrings.editCycleSettings,
            subtitle:
                '${AppStrings.dayCount(profile.settings.averageCycleLength)} · '
                '${_menopauseLabel(profile.settings.menopauseStatus)}',
            accent: accent,
            onTap: onEdit,
            showDivider: false,
            compact: true,
          ),
        ],
      ),
    );
  }

  String _cycleStatusLabel(CycleStatus? status) {
    return switch (status) {
      CycleStatus.normal => AppStrings.normal,
      CycleStatus.abnormal => AppStrings.review,
      _ => AppStrings.newLabel,
    };
  }

  String _regularityLabel(CycleRegularity? regularity) {
    return switch (regularity) {
      CycleRegularity.regular => AppStrings.regular,
      CycleRegularity.irregular => AppStrings.variable,
      _ => AppStrings.newLabel,
    };
  }

  String _menopauseLabel(MenopauseStatus status) {
    return switch (status) {
      MenopauseStatus.none => AppStrings.noMenopause,
      MenopauseStatus.pre => AppStrings.preMenopause,
      MenopauseStatus.peri => AppStrings.periMenopause,
      MenopauseStatus.post => AppStrings.postMenopause,
    };
  }
}

class _LabResultsCard extends StatelessWidget {
  final UserSettings settings;
  final Color accent;
  final VoidCallback onEdit;

  const _LabResultsCard({
    required this.settings,
    required this.accent,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final availableDefinitions = LabTestCatalog.definitions.where((definition) {
      final result = settings.labResults[definition.id];
      return result != null && result.value.trim().isNotEmpty;
    }).toList();
    return _SurfaceCard(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (availableDefinitions.isEmpty)
              InkWell(
                key: const ValueKey('profile_lab_results_empty'),
                borderRadius: BorderRadius.circular(15),
                onTap: onEdit,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: 0.09),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.science_outlined,
                          size: 21,
                          color: accent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppStrings.emptyLaboratoryResultsHint,
                          style: const TextStyle(
                            fontFamily: 'Karla',
                            fontSize: 12,
                            height: 1.35,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: accent),
                    ],
                  ),
                ),
              )
            else ...[
              if (settings.labTestDate != null ||
                  settings.labTestFasting != null) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 7,
                  children: [
                    if (settings.labTestDate != null)
                      _LabMetaChip(
                        icon: Icons.calendar_month_outlined,
                        label: settings.labTestDate!.toDotFormat(),
                        accent: accent,
                      ),
                    if (settings.labTestFasting != null)
                      _LabMetaChip(
                        icon: Icons.restaurant_outlined,
                        label: settings.labTestFasting!
                            ? AppStrings.fasting
                            : AppStrings.nonFasting,
                        accent: accent,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              for (
                var index = 0;
                index < availableDefinitions.length;
                index++
              ) ...[
                _LabResultRow(
                  definition: availableDefinitions[index],
                  result: settings.labResults[availableDefinitions[index].id]!,
                ),
                if (index < availableDefinitions.length - 1)
                  const _SoftDivider(),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _LabMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;

  const _LabMetaChip({
    required this.icon,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: accent),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Karla',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _LabResultRow extends StatelessWidget {
  final LabTestDefinition definition;
  final LabResult result;

  const _LabResultRow({required this.definition, required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              definition.label(AppStrings.isTurkish),
              style: const TextStyle(
                fontFamily: 'Karla',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${result.value} ${result.unit}',
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontFamily: 'Karla',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String badge;
  final bool badgePositive;
  final Color accent;

  const _CycleMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.badge,
    required this.badgePositive,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.09),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 19, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Karla',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Karla',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: (badgePositive ? AppColors.success : accent).withValues(
                alpha: 0.10,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge,
              style: TextStyle(
                fontFamily: 'Karla',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: badgePositive ? AppColors.success : accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatternCard extends StatelessWidget {
  final List<PersonalInsight> insights;
  final Color accent;

  const _PatternCard({required this.insights, required this.accent});

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) {
      return _SurfaceCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.auto_graph_rounded, color: accent, size: 21),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.patternsForming,
                      style: const TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.patternsFormingDescription,
                      style: const TextStyle(
                        fontFamily: 'Karla',
                        fontSize: 12,
                        height: 1.35,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _SurfaceCard(
      child: Column(
        children: [
          for (var index = 0; index < insights.length; index++) ...[
            _PatternRow(insight: insights[index], accent: accent, index: index),
            if (index != insights.length - 1) const _SoftDivider(),
          ],
        ],
      ),
    );
  }
}

class _PatternRow extends StatelessWidget {
  final PersonalInsight insight;
  final Color accent;
  final int index;

  const _PatternRow({
    required this.insight,
    required this.accent,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final primary = insight.primaryLabel == null
        ? null
        : AppStrings.localizeInsightFeature(insight.primaryLabel!);
    final title =
        primary ??
        switch (insight.kind) {
          PersonalInsightKind.dataBuilding => AppStrings.patternsForming,
          PersonalInsightKind.medicationAdherence ||
          PersonalInsightKind.medicationSkipSymptomAssociation =>
            AppStrings.medicationRoutine,
          PersonalInsightKind.moodCyclePhaseAssociation =>
            AppStrings.moodPattern,
          _ => AppStrings.recurringPattern,
        };
    final activeBars = insight.evidenceCount.clamp(1, 7);
    final colors = [accent, AppColors.secondary, AppColors.info];
    final rowColor = colors[index % colors.length];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: rowColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Karla',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  AppStrings.patternEvidence(insight.evidenceCount),
                  style: const TextStyle(
                    fontFamily: 'Karla',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (barIndex) {
              final isActive = barIndex < activeBars;
              return Container(
                width: 3,
                height: 7 + (barIndex % 4) * 3,
                margin: const EdgeInsets.only(left: 3),
                decoration: BoxDecoration(
                  color: isActive
                      ? rowColor.withValues(alpha: 0.76)
                      : AppColors.outline,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final ProfileViewModel profile;
  final Color accent;
  final VoidCallback onEditProfile;
  final VoidCallback onEditMedication;
  final VoidCallback onDoctorReport;
  final VoidCallback onDreams;
  final VoidCallback onPrivacy;
  final VoidCallback onHelp;

  const _AccountCard({
    required this.profile,
    required this.accent,
    required this.onEditProfile,
    required this.onEditMedication,
    required this.onDoctorReport,
    required this.onDreams,
    required this.onPrivacy,
    required this.onHelp,
  });

  @override
  Widget build(BuildContext context) {
    final settings = profile.settings;
    final personalParts = <String>[
      if (settings.age != null) AppStrings.ageYears(settings.age!),
      if (settings.height != null) '${settings.height!.toStringAsFixed(0)} cm',
      if (settings.weight != null) '${settings.weight!.toStringAsFixed(0)} kg',
    ];
    final medicineCount =
        settings.dailyMedications.length +
        settings.dailySupplements.length +
        settings.dailySkincare.length;
    final dreamCount = context
        .read<LocalStorageService>()
        .loadAllLogs()
        .where((log) => log.dreamNote?.trim().isNotEmpty ?? false)
        .length;

    return _SurfaceCard(
      child: Column(
        children: [
          _AccountRow(
            icon: Icons.person_outline_rounded,
            title: AppStrings.personalDetails,
            subtitle: personalParts.isEmpty
                ? AppStrings.completeProfile
                : personalParts.join(' · '),
            accent: accent,
            onTap: onEditProfile,
          ),
          _AccountRow(
            icon: Icons.notifications_none_rounded,
            title: AppStrings.medicationsSupplementsAndSkincare,
            subtitle: medicineCount == 0
                ? AppStrings.noPlanAdded
                : AppStrings.savedPlans(medicineCount),
            accent: accent,
            onTap: onEditMedication,
          ),
          _AccountRow(
            icon: Icons.description_outlined,
            title: AppStrings.doctorReport,
            subtitle: context.watch<PremiumPurchaseService>().isPremium
                ? AppStrings.viewAndShareReport
                : AppStrings.premiumRequired,
            accent: accent,
            onTap: onDoctorReport,
          ),
          _AccountRow(
            icon: Icons.nights_stay_outlined,
            title: AppStrings.myDreams,
            subtitle: dreamCount == 0
                ? AppStrings.noDreamRecords
                : AppStrings.dreamRecordCount(dreamCount),
            accent: accent,
            onTap: onDreams,
          ),
          _AccountRow(
            icon: Icons.shield_outlined,
            title: AppStrings.privacyAndData,
            subtitle: AppStrings.privacyCenter,
            accent: accent,
            onTap: onPrivacy,
          ),
          _AccountRow(
            icon: Icons.help_outline_rounded,
            title: AppStrings.helpAndSupport,
            subtitle: AppStrings.helpAndSupportSubtitle,
            accent: accent,
            onTap: onHelp,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;
  final bool showDivider;
  final bool compact;

  const _AccountRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
    this.showDivider = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 17 : 18,
                vertical: compact ? 13 : 15,
              ),
              child: Row(
                children: [
                  Container(
                    width: compact ? 34 : 39,
                    height: compact ? 34 : 39,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.085),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: compact ? 17 : 19, color: accent),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Karla',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Karla',
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 21,
                    color: accent.withValues(alpha: 0.68),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider) const _SoftDivider(),
      ],
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;

  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.78)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF574C44).withValues(alpha: 0.055),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _SoftDivider extends StatelessWidget {
  const _SoftDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 68),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.outline.withValues(alpha: 0.70),
      ),
    );
  }
}
