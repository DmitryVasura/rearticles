import 'dart:convert';

import 'package:re_articles/features/articles/data/models/tag_model.dart';

class ArticleModel {
  final String title;
  final String text;
  final String preview;
  final int likes;
  final int views;
  final int id;
  final String difficulty;
  final List<TagModel> tags;
  final int? authorId;
  final String? authorName;
  final bool likedByMe;

  const ArticleModel({
    required this.id,
    required this.title,
    required this.text,
    required this.preview,
    required this.likes,
    required this.views,
    required this.difficulty,
    required this.tags,
    this.authorId,
    this.authorName,
    this.likedByMe = false,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final rawText = json['text'];

    final String text;

    if (rawText is String) {
      text = rawText;
    } else {
      text = jsonEncode(rawText);
    }

    final tagsJson = json['tags'] as List<dynamic>? ?? [];
    final author = json['author'] as Map<String, dynamic>?;

    return ArticleModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      text: text,
      preview: _toPreview(text),
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
      difficulty: json['difficulty'] as String? ?? 'normal',
      tags: tagsJson.map((tag) => TagModel.fromJson(tag)).toList(),
      authorId: (author?['id'] as num?)?.toInt(),
      authorName: author?['username'] as String?,
      likedByMe: json['likedByMe'] as bool? ?? false,
    );
  }

  ArticleModel copyWith({
    int? likes,
    bool? likedByMe,
  }) {
    return ArticleModel(
      id: id,
      title: title,
      text: text,
      preview: preview,
      likes: likes ?? this.likes,
      views: views,
      difficulty: difficulty,
      tags: tags,
      authorId: authorId,
      authorName: authorName,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }

  // Превью считаем один раз при загрузке, а не при каждой перерисовке.
  static String _toPreview(String raw) {
    try {
      final decoded = jsonDecode(raw);

      if (decoded is List) {
        final buffer = StringBuffer();

        for (final op in decoded) {
          if (op is Map && op['insert'] is String) {
            buffer.write(op['insert']);
          }
        }

        return buffer.toString().trim();
      }
    } catch (_) {}

    return raw;
  }
}