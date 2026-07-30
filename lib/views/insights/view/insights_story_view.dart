part of 'insights_view.dart';

/// Kişisel içgörüleri kaynak tasarımdaki hikâye akışıyla gösterir.
class InsightsView extends StatefulWidget {
  final VoidCallback? onClose;

  const InsightsView({super.key, this.onClose});

  @override
  State<InsightsView> createState() => _InsightsViewState();
}

class _InsightsViewState extends State<InsightsView> {
  final PageController _pageController = PageController();
  Timer? _autoAdvance;
  int _index = 0;
  int _knownStoryCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final viewModel = context.read<InsightsViewModel>();
      if (viewModel.insights.isEmpty) {
        viewModel.loadData();
      }
    });
  }

  @override
  void dispose() {
    _autoAdvance?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    final calculator = context.watch<DashboardViewModel>().periodCalculator;
    final phase = calculator?.currentPhase ?? CyclePhase.follicular;
    final accent = _phaseColor(phase);

    return Consumer<InsightsViewModel>(
      builder: (context, viewModel, _) {
        final insights = viewModel.insights;
        _syncStoryCount(insights.length);

        return Scaffold(
          backgroundColor: Color.lerp(Colors.white, accent, 0.08),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(Colors.white, accent, 0.035)!,
                  Color.lerp(Colors.white, accent, 0.20)!,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _StoryProgress(
                    count: insights.isEmpty ? 1 : insights.length,
                    index: _index,
                    accent: accent,
                  ),
                  _StoryHeader(accent: accent, onClose: _close),
                  if (viewModel.isLoading && insights.isEmpty)
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(color: accent),
                      ),
                    )
                  else if (insights.isEmpty)
                    Expanded(
                      child: _EmptyInsightStory(
                        accent: accent,
                        onClose: _close,
                      ),
                    )
                  else ...[
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: insights.length,
                        onPageChanged: (value) {
                          setState(() => _index = value);
                          _scheduleAutoAdvance(insights.length);
                        },
                        itemBuilder: (context, index) {
                          final insight = insights[index];
                          return _InsightStoryPage(
                            insight: insight,
                            presentation: _InsightPresentation.from(insight),
                            accent: accent,
                          );
                        },
                      ),
                    ),
                    _StoryNavigation(
                      accent: accent,
                      canGoBack: _index > 0,
                      isLast: _index == insights.length - 1,
                      onBack: () => _goTo(_index - 1, insights.length),
                      onNext: () {
                        if (_index == insights.length - 1) {
                          _close();
                        } else {
                          _goTo(_index + 1, insights.length);
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _syncStoryCount(int count) {
    if (_knownStoryCount == count) return;
    _knownStoryCount = count;
    if (count == 0) {
      _autoAdvance?.cancel();
      return;
    }
    if (_index >= count) {
      _index = 0;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scheduleAutoAdvance(count);
    });
  }

  void _scheduleAutoAdvance(int count) {
    _autoAdvance?.cancel();
    if (count < 2) return;
    _autoAdvance = Timer(const Duration(seconds: 9), () {
      if (!mounted) return;
      _goTo((_index + 1) % count, count);
    });
  }

  void _goTo(int target, int count) {
    if (target < 0 || target >= count || !_pageController.hasClients) return;
    _pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  void _close() {
    _autoAdvance?.cancel();
    if (widget.onClose != null) {
      widget.onClose!();
      return;
    }
    Navigator.of(context).maybePop();
  }

  Color _phaseColor(CyclePhase phase) {
    return switch (phase) {
      CyclePhase.menstrual => AppColors.periodPrimary,
      CyclePhase.follicular => AppColors.primary,
      CyclePhase.ovulation => AppColors.ovulation,
      CyclePhase.luteal => AppColors.lutealDark,
    };
  }
}

class _StoryProgress extends StatelessWidget {
  final int count;
  final int index;
  final Color accent;

  const _StoryProgress({
    required this.count,
    required this.index,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          for (var item = 0; item < count; item++) ...[
            Expanded(
              child: Container(
                height: 4,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(99),
                ),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: item < index ? 1 : (item == index ? 0.62 : 0),
                  child: ColoredBox(color: accent),
                ),
              ),
            ),
            if (item != count - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _StoryHeader extends StatelessWidget {
  final Color accent;
  final VoidCallback onClose;

  const _StoryHeader({required this.accent, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppStrings.insightStoryHeader,
              style: TextStyle(
                color: accent,
                fontFamily: 'Karla',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.9,
              ),
            ),
          ),
          Semantics(
            button: true,
            label: AppStrings.cancel,
            child: IconButton(
              onPressed: onClose,
              style: IconButton.styleFrom(
                fixedSize: const Size.square(38),
                backgroundColor: Colors.white.withValues(alpha: 0.72),
              ),
              icon: const Icon(Icons.close_rounded, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightStoryPage extends StatelessWidget {
  final PersonalInsight insight;
  final _InsightPresentation presentation;
  final Color accent;

  const _InsightStoryPage({
    required this.insight,
    required this.presentation,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final chain = _chainFor(insight);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.24),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            AppStrings.personalInsightsPreviewTitle.toUpperCase(),
            style: TextStyle(
              color: accent,
              fontFamily: 'Karla',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.9,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            presentation.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: 'CormorantGaramond',
              fontSize: 42,
              height: 1.02,
              fontWeight: FontWeight.w600,
              letterSpacing: -1.1,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            presentation.body,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontFamily: 'Karla',
              fontSize: 14,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (var item = 0; item < chain.length; item++) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.76),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    chain[item],
                    style: TextStyle(
                      color: accent,
                      fontFamily: 'Karla',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (item != chain.length - 1)
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 15,
                    color: AppColors.textSecondary,
                  ),
              ],
            ],
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.48),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.insightExplanationLabel,
                  style: TextStyle(
                    color: accent,
                    fontFamily: 'Karla',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.7,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  presentation.evidence,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'Karla',
                    fontSize: 12.5,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.insightsDisclaimer,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontFamily: 'Karla',
                    fontSize: 10.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _chainFor(PersonalInsight value) {
    return switch (value.kind) {
      PersonalInsightKind.cycleLength ||
      PersonalInsightKind.cycleVariation ||
      PersonalInsightKind.cycleTimingReview ||
      PersonalInsightKind.periodDuration ||
      PersonalInsightKind.periodTrackingStarted ||
      PersonalInsightKind.periodSymptomPattern ||
      PersonalInsightKind.periodDurationReview => [
        AppStrings.myCycles,
        AppStrings.dailyLog,
      ],
      PersonalInsightKind.frequentMood ||
      PersonalInsightKind.moodCyclePhaseAssociation => [
        AppStrings.mood,
        AppStrings.myCycles,
      ],
      PersonalInsightKind.energyCyclePhaseAssociation => [
        AppStrings.energyLevel,
        AppStrings.myCycles,
      ],
      PersonalInsightKind.frequentNutrition => [
        AppStrings.nutrition,
        AppStrings.energyLevel,
      ],
      PersonalInsightKind.foodObservationStarted ||
      PersonalInsightKind.foodPatternBuilding ||
      PersonalInsightKind.foodSensitivityAssociation => [
        AppStrings.nutrition,
        AppStrings.dailyFactors,
      ],
      PersonalInsightKind.medicationAdherence ||
      PersonalInsightKind.medicationSkipSymptomAssociation => [
        AppStrings.medications,
        AppStrings.dailyLog,
      ],
      PersonalInsightKind.dischargeBaselineObservation ||
      PersonalInsightKind.fertileDischargeSignal ||
      PersonalInsightKind.menstrualDischargeContext ||
      PersonalInsightKind.dischargeHealthNotice => [
        AppStrings.vaginalDischarge,
        AppStrings.myCycles,
      ],
      _ => [AppStrings.dailyLog, AppStrings.myCycles],
    };
  }
}

class _StoryNavigation extends StatelessWidget {
  final Color accent;
  final bool canGoBack;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const _StoryNavigation({
    required this.accent,
    required this.canGoBack,
    required this.isLast,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 22),
      child: Row(
        children: [
          Semantics(
            button: true,
            label: AppStrings.previousInsight,
            child: IconButton(
              onPressed: canGoBack ? onBack : null,
              style: IconButton.styleFrom(
                fixedSize: const Size.square(56),
                backgroundColor: Colors.white.withValues(alpha: 0.58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.arrow_back_rounded, size: 21),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton.icon(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Karla',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(
                isLast ? AppStrings.insightStoryDone : AppStrings.next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyInsightStory extends StatelessWidget {
  final Color accent;
  final VoidCallback onClose;

  const _EmptyInsightStory({required this.accent, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 40, 30, 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.insightsEmptyTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppStrings.insightsEmptyDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Karla',
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onClose,
            style: FilledButton.styleFrom(backgroundColor: accent),
            child: Text(AppStrings.back),
          ),
        ],
      ),
    );
  }
}
