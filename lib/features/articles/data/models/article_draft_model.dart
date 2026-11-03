import 'dart:convert';

import 'package:re_articles/features/articles/domain/entities/article_draft.dart';

class ArticleDraftModel extends ArticleDraft {
  const ArticleDraftModel({
    required super.id,
    required super.title,
    required super.content,
    required super.updatedAt,
    super.articleId,
    super.tags,
    super.difficulty,
  });

  factory ArticleDraftModel.fromEntity(ArticleDraft draft) {
    return ArticleDraftModel(
      id: draft.id,
      title: draft.title,
      content: draft.content,
      updatedAt: draft.updatedAt,
      articleId: draft.articleId,
      tags: draft.tags,
      difficulty: draft.difficulty,
    );
  }

  factory ArticleDraftModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ArticleDraftModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      content: List<dynamic>.from(
        json['content'] as List? ?? [],
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
      // Старые черновики этих полей не содержат, это нормально.
      articleId: (json['articleId'] as num?)?.toInt(),
      tags: List<String>.from(json['tags'] as List? ?? const []),
      difficulty: json['difficulty'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'updatedAt': updatedAt.toIso8601String(),
      'articleId': articleId,
      'tags': tags,
      'difficulty': difficulty,
    };
  }

  String encode() => jsonEncode(toJson());

  factory ArticleDraftModel.decode(String source) {
    return ArticleDraftModel.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }
}