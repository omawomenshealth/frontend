import 'package:flutter/material.dart';

import '../../../core/theme/oma_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../model/article_model.dart';

/// Yalnızca sunucu tarafından erişim izni verilmiş makale içeriğini gösterir.
class ArticleDetailView extends StatelessWidget {
  final Article article;

  const ArticleDetailView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    AppStrings.of(context);
    return Scaffold(
      backgroundColor: context.omaTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(OmaSpacing.sm),
              child: CircleAvatar(
                backgroundColor: OmaPalette.onMedia.withValues(alpha: 0.84),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: context.omaTheme.foreground,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      article.cardColor,
                      article.cardColor.withValues(alpha: 0.78),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -30,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: OmaPalette.onMedia.withValues(
                          alpha: 0.1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      bottom: -20,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: OmaPalette.onMedia.withValues(
                          alpha: 0.08,
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(OmaSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                _HeroBadge(
                                  label: article.localizedTopic.toUpperCase(),
                                ),
                                if (article.isPremium) ...[
                                  const SizedBox(width: OmaSpacing.sm),
                                  _HeroBadge(
                                    label: AppStrings.premium,
                                    icon: Icons.workspace_premium_rounded,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: OmaSpacing.md),
                            Text(
                              article.title,
                              style: TextStyle(
                                fontFamily: 'CormorantGaramond',
                                fontSize: OmaTypeScale.display,
                                fontWeight: FontWeight.w600,
                                color: OmaPalette.onMedia,
                                height: 1.02,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    color: OmaPalette.mediaScrimMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(OmaSpacing.xl, OmaSpacing.xxl, OmaSpacing.xl, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAuthorRow(context),
                  const SizedBox(height: OmaSpacing.xxl),
                  _buildSummaryBox(context),
                  const SizedBox(height: OmaSpacing.xxl),
                  if (article.contentBlocks.isEmpty)
                    Text(
                      AppStrings.articleNotPublished,
                      style: TextStyle(
                        color: context.omaTheme.muted,
                        height: 1.6,
                      ),
                    )
                  else
                    ...article.contentBlocks.map(
                      (block) => _buildContentBlock(context, block),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorRow(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(OmaSpacing.sm),
          decoration: BoxDecoration(
            color: article.cardColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.menu_book_rounded,
            size: 18,
            color: article.cardColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.healthTeam,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: context.omaTheme.foreground,
                ),
              ),
              Text(
                AppStrings.generalInformation,
                style: TextStyle(fontSize: 11, color: context.omaTheme.muted),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: context.omaTheme.surface,
            borderRadius: BorderRadius.circular(OmaRadius.sm),
          ),
          child: Row(
            children: [
              Icon(Icons.timer_outlined, size: 14, color: article.cardColor),
              const SizedBox(width: OmaSpacing.xs),
              Text(
                AppStrings.readTimeMinutes(article.readTimeMinutes),
                style: TextStyle(
                  fontSize: OmaTypeScale.caption,
                  fontWeight: FontWeight.w600,
                  color: article.cardColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(OmaSpacing.lg),
      decoration: BoxDecoration(
        color: context.omaTheme.surface,
        borderRadius: BorderRadius.circular(OmaRadius.lg),
        border: Border.all(
          color: article.cardColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: article.cardColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: article.cardColor,
              size: 20,
            ),
          ),
          const SizedBox(width: OmaSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.shortSummary,
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: OmaTypeScale.title,
                    fontWeight: FontWeight.w600,
                    color: context.omaTheme.foreground,
                  ),
                ),
                const SizedBox(height: OmaSpacing.xs),
                Text(
                  article.summary,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: context.omaTheme.muted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBlock(BuildContext context, String block) {
    if (block.startsWith('###')) {
      return Padding(
        padding: const EdgeInsets.only(top: OmaSpacing.xl, bottom: OmaSpacing.sm),
        child: Text(
          block.replaceFirst('###', '').trim(),
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: context.omaTheme.foreground,
          ),
        ),
      );
    }

    if (block.startsWith('•')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10, left: OmaSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '•',
              style: TextStyle(
                fontSize: OmaTypeScale.bodyLarge,
                fontWeight: FontWeight.bold,
                color: article.cardColor,
              ),
            ),
            const SizedBox(width: OmaSpacing.sm),
            Expanded(
              child: Text(
                block.substring(1).trim(),
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: context.omaTheme.muted,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: OmaSpacing.lg),
      child: Text(
        block,
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: context.omaTheme.muted,
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _HeroBadge({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: OmaSpacing.xs),
      decoration: BoxDecoration(
        color: OmaPalette.onMedia.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(OmaRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: OmaPalette.onMedia, size: 13),
            const SizedBox(width: OmaSpacing.xs),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: OmaTypeScale.micro,
              fontWeight: FontWeight.w800,
              color: OmaPalette.onMedia,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
