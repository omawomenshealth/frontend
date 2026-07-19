import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/premium_purchase_service.dart';
import '../model/article_model.dart';
import '../widgets/premium_paywall.dart';
import 'article_detail_view.dart';

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key});

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  List<Article> _articles = const [];
  String? _selectedTopic;
  bool _isLoading = true;
  String? _errorMessage;
  String? _openingArticleId;
  String? _loadedLanguageCode;

  List<String> get _topics {
    final values = _articles.map((article) => article.topic).toSet().toList()
      ..sort();
    return [AppStrings.all, ...values];
  }

  Map<String, List<Article>> get _groupedArticles {
    final visible = _selectedTopic == null
        ? _articles
        : _articles
              .where((article) => article.topic == _selectedTopic)
              .toList();
    final grouped = <String, List<Article>>{};
    for (final article in visible) {
      (grouped[article.topic] ??= []).add(article);
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
        if (_selectedTopic != null &&
            !_articles.any((article) => article.topic == _selectedTopic)) {
          _selectedTopic = null;
        }
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

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    final isPremium = context.watch<PremiumPurchaseService>().isPremium;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '📖 ${AppStrings.articles}',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD54F).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.workspace_premium_rounded,
                            size: 16,
                            color: Color(0xFFD49B00),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppStrings.premium,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9A7000),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Text(
                AppStrings.expertArticlesSubtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            if (_articles.isNotEmpty) _buildTopicFilters(),
            const SizedBox(height: 12),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicFilters() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _topics.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final topic = _topics[index];
          final isAll = index == 0;
          final isSelected = isAll
              ? _selectedTopic == null
              : _selectedTopic == topic;
          return GestureDetector(
            onTap: () => setState(() => _selectedTopic = isAll ? null : topic),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textHint.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Text(
                isAll ? AppStrings.all : AppStrings.localizeArticleTopic(topic),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _articles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _articles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppColors.textHint,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadArticles,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_groupedArticles.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noArticlesForTopic,
          style: const TextStyle(color: AppColors.textHint),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadArticles,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: _groupedArticles.length,
        itemBuilder: (context, index) {
          final topic = _groupedArticles.keys.elementAt(index);
          return _buildTopicSection(topic, _groupedArticles[topic]!);
        },
      ),
    );
  }

  Widget _buildTopicSection(String topic, List<Article> articles) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: articles.first.cardColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.localizeArticleTopic(topic),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 168,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: articles.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) =>
                  _buildArticleCard(articles[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(Article article) {
    final isOpening = _openingArticleId == article.id;
    return GestureDetector(
      onTap: isOpening ? null : () => _openArticle(article),
      child: Container(
        width: 226,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              article.cardColor,
              article.cardColor.withValues(alpha: 0.72),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: article.cardColor.withValues(alpha: 0.28),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildCardBadge(
                      article.isPremium ? AppStrings.premium : AppStrings.free,
                      article.isPremium
                          ? Icons.workspace_premium_rounded
                          : Icons.lock_open_rounded,
                    ),
                    const Spacer(),
                    Text(
                      '⏱ ${article.readTime}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  article.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  article.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.86),
                    height: 1.3,
                  ),
                ),
              ],
            ),
            if (!article.canAccess)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.28),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            if (isOpening)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBadge(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
