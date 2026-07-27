import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

/// Sunucudan gelen makale özeti veya detay modeli.
class Article {
  final String id;
  final String title;
  final String summary;
  final String topic;
  final String imageKey;
  final String displaySection;
  final String displayStyle;
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
    this.imageKey = '',
    this.displaySection = '',
    this.displayStyle = 'grid',
    required this.readTimeMinutes,
    required this.cardColor,
    required this.isPremium,
    required this.canAccess,
    this.contentBlocks = const [],
  });

  String get readTime => AppStrings.readTimeMinutes(readTimeMinutes);
  String get localizedTopic => AppStrings.localizeArticleTopic(topic);

  factory Article.fromJson(Map<String, dynamic> json) {
    final topic = json['topic'] as String? ?? AppStrings.generalHealth;
    final imageKey = (json['imageKey'] as String? ?? '').trim();
    final displaySection = (json['displaySection'] as String? ?? '').trim();
    final displayStyle = (json['displayStyle'] as String? ?? '').trim();
    return Article(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      topic: topic,
      imageKey: imageKey.isEmpty ? _defaultImageKey(topic) : imageKey,
      displaySection: displaySection.isEmpty
          ? _defaultDisplaySection(topic)
          : displaySection,
      displayStyle: displayStyle == 'grid' || displayStyle == 'row'
          ? displayStyle
          : _defaultDisplayStyle(topic),
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

  static String _defaultImageKey(String topic) {
    final value = topic.toLowerCase();
    if (value.contains('beslen') || value.contains('nutrition')) {
      return 'nutrition';
    }
    if (value.contains('uyku') || value.contains('sleep')) return 'sleep';
    if (value.contains('egzersiz') ||
        value.contains('exercise') ||
        value.contains('movement')) {
      return 'movement';
    }
    if (value.contains('kadın') ||
        value.contains('women') ||
        value.contains('ritual')) {
      return 'ritual';
    }
    return '';
  }

  static String _defaultDisplaySection(String topic) {
    final value = topic.toLowerCase();
    if (value.contains('beslen') || value.contains('nutrition')) {
      return 'nourish';
    }
    if (value.contains('uyku') || value.contains('sleep')) return 'reads';
    if (value.contains('egzersiz') ||
        value.contains('exercise') ||
        value.contains('movement')) {
      return 'movement';
    }
    if (value.contains('kadın') ||
        value.contains('women') ||
        value.contains('ritual')) {
      return 'rituals';
    }
    return topic;
  }

  static String _defaultDisplayStyle(String topic) {
    return _defaultDisplaySection(topic) == 'rituals' ? 'row' : 'grid';
  }

  static Color _parseColor(String? value) {
    final hex = (value ?? '#9CAB84').replaceFirst('#', '');
    final argb = hex.length == 6 ? 'FF$hex' : hex;
    return Color(int.tryParse(argb, radix: 16) ?? 0xFF9CAB84);
  }
}
