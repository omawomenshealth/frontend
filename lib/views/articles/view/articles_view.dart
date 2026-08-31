import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/period_calculator.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/premium_purchase_service.dart';
import '../../../localization/generated/strings.g.dart';
import '../../dashboard/viewmodel/dashboard_view_model.dart';
import '../model/article_model.dart';
import '../widgets/premium_paywall.dart';
import 'article_detail_view.dart';

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key});

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  static const _editorialImages = <String>[
    'assets/images/explore-movement.jpg',
    'assets/images/explore-intimacy.jpg',
    'assets/images/explore-ritual.jpg',
    'assets/images/explore-nutrition.jpg',
    'assets/images/explore-sleep.jpg',
    'assets/images/explore-reflection.jpg',
  ];

  final TextEditingController _searchController = TextEditingController();
  final Set<String> _savedArticleIds = <String>{};

  List<Article> _articles = const [];
  String? _selectedTopic;
  String? _selectedSection;
  String _query = '';
  bool _savedOnly = false;
  bool _isLoading = true;
  String? _errorMessage;
  String? _openingArticleId;
  String? _loadedLanguageCode;

  List<Article> get _visibleArticles {
    final normalizedQuery = _query.trim().toLowerCase();
    return _articles
        .where((article) {
          if (_selectedTopic != null &&
              !_matchesQuickTopic(article, _selectedTopic!)) {
            return false;
          }
          if (_selectedSection != null &&
              article.displaySection != _selectedSection) {
            return false;
          }
          if (_savedOnly && !_savedArticleIds.contains(article.id)) {
            return false;
          }
          if (normalizedQuery.isEmpty) {
            return true;
          }
          return article.title.toLowerCase().contains(normalizedQuery) ||
              article.summary.toLowerCase().contains(normalizedQuery) ||
              article.localizedTopic.toLowerCase().contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  Map<String, List<Article>> get _groupedArticles {
    final grouped = <String, List<Article>>{};
    for (final article in _visibleArticles) {
      final section = article.displaySection.isEmpty
          ? article.topic
          : article.displaySection;
      (grouped[section] ??= []).add(article);
    }
    return grouped;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppStrings.of(context);
    if (_loadedLanguageCode == AppStrings.languageCode) return;
    _loadedLanguageCode = AppStrings.languageCode;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadArticles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadArticles() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final premium = context.read<PremiumPurchaseService>();
      final api = context.read<ApiService>();
      await premium.refreshEntitlement();
      final json = await api.fetchArticles();
      final articles = json.map(Article.fromJson).toList(growable: false);
      if (!mounted) return;
      setState(() {
        _articles = articles;
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = AppStrings.articlesLoadFailed);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _openArticle(Article preview) async {
    if (!preview.canAccess) {
      await _openPaywall();
      return;
    }

    setState(() => _openingArticleId = preview.id);
    try {
      final json = await context.read<ApiService>().fetchArticle(preview.id);
      final article = Article.fromJson(json);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ArticleDetailView(article: article)),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.code == 'PREMIUM_REQUIRED') {
        await _openPaywall();
      } else {
        _showMessage(error.message);
      }
    } catch (_) {
      if (mounted) _showMessage(AppStrings.articleLoadFailed);
    } finally {
      if (mounted) setState(() => _openingArticleId = null);
    }
  }

  Future<void> _openPaywall() async {
    await showPremiumPaywall(context);
    if (!mounted) return;
    await context.read<PremiumPurchaseService>().refreshEntitlement();
    if (mounted) await _loadArticles();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _toggleSaved(Article article) {
    setState(() {
      if (!_savedArticleIds.remove(article.id)) {
        _savedArticleIds.add(article.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    final calculator = context.watch<DashboardViewModel>().periodCalculator;
    final phase = calculator?.currentPhase ?? CyclePhase.follicular;
    final accent = _phaseColor(phase);
    final membershipTier = context.watch<PremiumPurchaseService>().tier;

    return Scaffold(
      backgroundColor: Color.lerp(AppColors.scaffoldBackground, accent, 0.028),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _ExploreSearchHeader(
              controller: _searchController,
              accent: accent,
              savedOnly: _savedOnly,
              onChanged: (value) => setState(() => _query = value),
              onToggleSaved: () => setState(() => _savedOnly = !_savedOnly),
            ),
            Expanded(
              child: _buildBody(
                phase: phase,
                accent: accent,
                membershipTier: membershipTier,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody({
    required CyclePhase phase,
    required Color accent,
    required MembershipTier membershipTier,
  }) {
    if (_isLoading && _articles.isEmpty) {
      return Center(child: CircularProgressIndicator(color: accent));
    }

    if (_errorMessage != null && _articles.isEmpty) {
      return _ErrorState(
        message: _errorMessage!,
        accent: accent,
        onRetry: _loadArticles,
      );
    }

    final groups = _groupedArticles.entries.toList(growable: false);
    return RefreshIndicator(
      color: accent,
      onRefresh: _loadArticles,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(bottom: 122),
        children: [
          _ExploreHero(
            phase: phase,
            accent: accent,
            membershipTier: membershipTier,
          ),
          if (_articles.isNotEmpty) ...[
            const SizedBox(height: 25),
            _buildQuickTopics(accent),
          ],
          if (groups.isEmpty)
            _EmptyArticlesState(
              accent: accent,
              savedOnly: _savedOnly,
              hasQuery: _query.trim().isNotEmpty,
              onClear: () {
                _searchController.clear();
                setState(() {
                  _query = '';
                  _selectedTopic = null;
                  _selectedSection = null;
                  _savedOnly = false;
                });
              },
            )
          else
            for (var index = 0; index < groups.length; index++)
              _buildTopicSection(
                topic: groups[index].key,
                articles: groups[index].value,
                sectionIndex: index,
                accent: accent,
              ),
        ],
      ),
    );
  }

  Widget _buildQuickTopics(Color accent) {
    final topics = <({String id, String label, IconData icon})>[
      (
        id: 'energy',
        label: AppStrings.exploreEnergy,
        icon: Icons.wb_sunny_outlined,
      ),
      (
        id: 'sleep',
        label: AppStrings.exploreSleep,
        icon: Icons.bedtime_outlined,
      ),
      (
        id: 'intimacy',
        label: AppStrings.exploreIntimacy,
        icon: Icons.favorite_border_rounded,
      ),
      (id: 'focus', label: AppStrings.exploreFocus, icon: Icons.adjust_rounded),
      (
        id: 'nourish',
        label: AppStrings.exploreNourish,
        icon: Icons.ramen_dining_outlined,
      ),
    ];

    return SizedBox(
      height: 94,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: topics.length,
        separatorBuilder: (_, _) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final topic = topics[index];
          final selected = _selectedTopic == topic.id;
          return _QuickTopicButton(
            label: topic.label,
            icon: topic.icon,
            accent: accent,
            selected: selected,
            onTap: () => setState(() {
              _selectedTopic = selected ? null : topic.id;
              _selectedSection = null;
            }),
          );
        },
      ),
    );
  }

  Widget _buildTopicSection({
    required String topic,
    required List<Article> articles,
    required int sectionIndex,
    required Color accent,
  }) {
    final localizedTopic = AppStrings.localizeExploreSection(topic);
    final useRows =
        articles.first.displayStyle == 'row' ||
        (articles.first.displaySection.isEmpty && sectionIndex.isOdd);
    return Padding(
      padding: const EdgeInsets.only(top: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    localizedTopic,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'CormorantGaramond',
                      fontSize: 27,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.35,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _selectedTopic = null;
                    _selectedSection = topic;
                  }),
                  style: TextButton.styleFrom(
                    foregroundColor: accent,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    AppStrings.viewAllUpper,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (useRows)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  for (var index = 0; index < articles.length; index++) ...[
                    _RitualArticleRow(
                      article: articles[index],
                      imagePath: _imageFor(articles[index], index),
                      isOpening: _openingArticleId == articles[index].id,
                      onTap: () => _openArticle(articles[index]),
                    ),
                    if (index != articles.length - 1)
                      const SizedBox(height: 11),
                  ],
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: articles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) => _EditorialArticleCard(
                  article: articles[index],
                  imagePath: _imageFor(articles[index], index),
                  saved: _savedArticleIds.contains(articles[index].id),
                  isOpening: _openingArticleId == articles[index].id,
                  onTap: () => _openArticle(articles[index]),
                  onToggleSaved: () => _toggleSaved(articles[index]),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _imageFor(Article article, int index) {
    const keyedImages = <String, String>{
      'movement': 'assets/images/explore-movement.jpg',
      'intimacy': 'assets/images/explore-intimacy.jpg',
      'ritual': 'assets/images/explore-ritual.jpg',
      'nutrition': 'assets/images/explore-nutrition.jpg',
      'sleep': 'assets/images/explore-sleep.jpg',
      'reflection': 'assets/images/explore-reflection.jpg',
    };
    final configuredImage = keyedImages[article.imageKey];
    if (configuredImage != null) return configuredImage;

    final seed = article.id.codeUnits.fold<int>(
      index,
      (value, unit) => value + unit,
    );
    return _editorialImages[seed.abs() % _editorialImages.length];
  }

  bool _matchesQuickTopic(Article article, String quickTopic) {
    final topic = article.topic.toLowerCase();
    final section = article.displaySection.toLowerCase();
    return switch (quickTopic) {
      'energy' =>
        section == 'movement' ||
            topic.contains('egzersiz') ||
            topic.contains('exercise'),
      'sleep' =>
        section == 'reads' || topic.contains('uyku') || topic.contains('sleep'),
      'intimacy' =>
        section == 'rituals' ||
            topic.contains('kadın') ||
            topic.contains('women'),
      'focus' => section == 'rituals' || topic.contains('pms'),
      'nourish' =>
        section == 'nourish' ||
            topic.contains('beslen') ||
            topic.contains('nutrition'),
      _ => true,
    };
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

class _ExploreSearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final Color accent;
  final bool savedOnly;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleSaved;

  const _ExploreSearchHeader({
    required this.controller,
    required this.accent,
    required this.savedOnly,
    required this.onChanged,
    required this.onToggleSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 10, 22, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.045),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3C322C).withValues(alpha: 0.035),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.exploreSearchHint,
                  hintStyle: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12.5,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 11),
          IconButton(
            tooltip: AppStrings.savedStories,
            onPressed: onToggleSaved,
            style: IconButton.styleFrom(
              fixedSize: const Size(48, 48),
              foregroundColor: savedOnly ? Colors.white : AppColors.textPrimary,
              backgroundColor: savedOnly
                  ? accent
                  : Colors.white.withValues(alpha: 0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
                side: BorderSide(
                  color: savedOnly
                      ? accent
                      : Colors.black.withValues(alpha: 0.045),
                ),
              ),
            ),
            icon: Icon(
              savedOnly
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreHero extends StatelessWidget {
  final CyclePhase phase;
  final Color accent;
  final MembershipTier membershipTier;

  const _ExploreHero({
    required this.phase,
    required this.accent,
    required this.membershipTier,
  });

  @override
  Widget build(BuildContext context) {
    final phaseName = switch (phase) {
      CyclePhase.menstrual => AppStrings.exploreMenstrualName,
      CyclePhase.follicular => AppStrings.exploreFollicularName,
      CyclePhase.ovulation => AppStrings.exploreOvulationName,
      CyclePhase.luteal => AppStrings.exploreLutealName,
    };
    final fertility = switch (phase) {
      CyclePhase.menstrual => AppStrings.exploreMenstrualDescription,
      CyclePhase.follicular => AppStrings.exploreFollicularDescription,
      CyclePhase.ovulation => AppStrings.exploreOvulationDescription,
      CyclePhase.luteal => AppStrings.exploreLutealDescription,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.explorePhaseDays(phaseName),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: 'CormorantGaramond',
                    fontSize: 34,
                    height: 1,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  fertility,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (membershipTier != MembershipTier.free)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Color.lerp(accent, Colors.white, 0.83),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded, color: accent, size: 13),
                  const SizedBox(width: 4),
                  Text(
                    membershipTier == MembershipTier.premium
                        ? t.premium.premiumPlanName
                        : t.premium.plusPlanName,
                    style: TextStyle(
                      color: accent,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickTopicButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;
  final bool selected;
  final VoidCallback onTap;

  const _QuickTopicButton({
    required this.label,
    required this.icon,
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 69,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: selected ? accent : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accent.withValues(alpha: selected ? 1 : 0.28),
                  ),
                ),
                child: Icon(
                  icon,
                  color: selected ? Colors.white : accent,
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditorialArticleCard extends StatelessWidget {
  final Article article;
  final String imagePath;
  final bool saved;
  final bool isOpening;
  final VoidCallback onTap;
  final VoidCallback onToggleSaved;

  const _EditorialArticleCard({
    required this.article,
    required this.imagePath,
    required this.saved,
    required this.isOpening,
    required this.onTap,
    required this.onToggleSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isOpening ? null : onTap,
        borderRadius: BorderRadius.circular(25),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3C322C).withValues(alpha: 0.13),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(imagePath, fit: BoxFit.cover),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x18000000),
                        Color(0xB3000000),
                      ],
                      stops: [0.3, 0.56, 1],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: onToggleSaved,
                    style: IconButton.styleFrom(
                      fixedSize: const Size(34, 34),
                      minimumSize: const Size(34, 34),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white.withValues(alpha: 0.78),
                      foregroundColor: AppColors.textPrimary,
                    ),
                    icon: Icon(
                      saved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      size: 18,
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          if (article.isPremium)
                            const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.lock_outline_rounded,
                                color: Colors.white70,
                                size: 11,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              article.localizedTopic.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'CormorantGaramond',
                          fontSize: 20,
                          height: 1.02,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(color: Color(0x33000000), blurRadius: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isOpening)
                  ColoredBox(
                    color: Colors.black.withValues(alpha: 0.25),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
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

class _RitualArticleRow extends StatelessWidget {
  final Article article;
  final String imagePath;
  final bool isOpening;
  final VoidCallback onTap;

  const _RitualArticleRow({
    required this.article,
    required this.imagePath,
    required this.isOpening,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.58),
      borderRadius: BorderRadius.circular(23),
      child: InkWell(
        onTap: isOpening ? null : onTap,
        borderRadius: BorderRadius.circular(23),
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: Image.asset(
                  imagePath,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'CormorantGaramond',
                        fontSize: 19,
                        height: 1.05,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${AppStrings.readTimeMinutes(article.readTimeMinutes)} · '
                      '${article.localizedTopic}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isOpening)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(
                  article.canAccess
                      ? Icons.chevron_right_rounded
                      : Icons.lock_outline_rounded,
                  color: AppColors.textHint,
                  size: 21,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Color accent;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.accent,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 46, color: accent),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: accent),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyArticlesState extends StatelessWidget {
  final Color accent;
  final bool savedOnly;
  final bool hasQuery;
  final VoidCallback onClear;

  const _EmptyArticlesState({
    required this.accent,
    required this.savedOnly,
    required this.hasQuery,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 58, 32, 20),
      child: Column(
        children: [
          Icon(
            savedOnly
                ? Icons.bookmark_border_rounded
                : Icons.auto_stories_outlined,
            color: accent,
            size: 44,
          ),
          const SizedBox(height: 13),
          Text(
            savedOnly
                ? AppStrings.exploreSavedEmpty
                : hasQuery
                ? AppStrings.exploreSearchEmpty
                : AppStrings.noArticlesForTopic,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: onClear,
            style: TextButton.styleFrom(foregroundColor: accent),
            child: Text(AppStrings.clearFilters),
          ),
        ],
      ),
    );
  }
}
