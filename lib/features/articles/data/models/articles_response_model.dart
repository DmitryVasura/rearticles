import 'package:re_articles/features/articles/data/models/article_model.dart';

class ArticlesResponseModel {
  final List<ArticleModel> articles;
  final int offset;
  final int limit;
  final int total;

  const ArticlesResponseModel({
    required this.articles,
    required this.offset,
    required this.limit,
    required this.total,
  });

  factory ArticlesResponseModel.fromJson(Map<String, dynamic> json) {
    final articlesJson = json['articles'] as List<dynamic>? ?? [];

    return ArticlesResponseModel(
      articles: articlesJson
          .map(
            (article) => ArticleModel.fromJson(
              Map<String, dynamic>.from(article as Map),
            ),
          )
          .toList(),
      offset: (json['offset'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}