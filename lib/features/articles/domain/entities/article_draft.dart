import 'dart:convert';

class ArticleDraft {
  final String id;
  final String title;
  final List<dynamic> content;
  final DateTime updatedAt;

  final int? articleId;
  final List<String> tags;
  final String? difficulty;

  const ArticleDraft({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
    this.articleId,
    this.tags = const [],
    this.difficulty,
  });

  ArticleDraft copyWith({
    String? title,
    List<dynamic>? content,
    DateTime? updatedAt,
  }) {
    return ArticleDraft(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      articleId: articleId,
      tags: tags,
      difficulty: difficulty,
    );
  }

  String get plainText {
    final buffer = StringBuffer();
    for (final op in content) {
      if (op is Map && op['insert'] is String) buffer.write(op['insert']);
    }
    return buffer.toString().trim();
  }

  bool get _hasEmbeds =>
      content.any((op) => op is Map && op['insert'] is Map);

  bool get isEmpty =>
      title.trim().isEmpty && plainText.isEmpty && !_hasEmbeds;

  Map<String, dynamic> toArticle() => {
    'id': DateTime.now().millisecondsSinceEpoch,
    'title': title.trim(),
    'text': jsonEncode(content),
    'likes': 0,
    'views': 0,
    'tags': tags,
    'difficulty': difficulty,
    'draftId': id,
    'articleId': articleId,
  };
}