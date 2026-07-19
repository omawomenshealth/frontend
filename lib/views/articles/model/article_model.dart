import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

/// Sunucudan gelen makale özeti veya detay modeli.
class Article {
  final String id;
  final String title;
  final String summary;
  final String topic;
  final int readTimeMinutes;
  final Color cardColor;
  final bool isPremium;
  final bool canAccess;
  final List<String> contentBlocks;

  const Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.topic,
    required this.readTimeMinutes,
    required this.cardColor,
    required this.isPremium,
    required this.canAccess,
    this.contentBlocks = const [],
  });

  String get readTime => AppStrings.dayCount(readTimeMinutes);
  String get localizedTopic => AppStrings.localizeArticleTopic(topic);

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      topic: json['topic'] as String? ?? AppStrings.generalHealth,
      readTimeMinutes: (json['readTimeMinutes'] as num?)?.toInt() ?? 1,
      cardColor: _parseColor(json['cardColor'] as String?),
      isPremium: json['isPremium'] as bool? ?? true,
      canAccess: json['canAccess'] as bool? ?? false,
      contentBlocks:
          (json['contentBlocks'] as List<dynamic>?)?.whereType<String>().toList(
            growable: false,
          ) ??
          const [],
    );
  }

  static Color _parseColor(String? value) {
    final hex = (value ?? '#9CAB84').replaceFirst('#', '');
    final argb = hex.length == 6 ? 'FF$hex' : hex;
    return Color(int.tryParse(argb, radix: 16) ?? 0xFF9CAB84);
  }
}
