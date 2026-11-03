import 'package:re_articles/features/articles/data/models/article_model.dart';
import 'package:re_articles/features/articles/data/models/articles_response_model.dart';
import 'package:re_articles/features/articles/domain/entities/article_scope.dart';

abstract class ArticleRepository {
  Future<ArticlesResponseModel> getArticles({
    required int offset,
    required int limit,
    ArticleScope scope = ArticleScope.all,
    int? authorId,
  });

  Future<void> likeArticle({
    required int articleId,
    required bool liked,
  });

  Future<ArticleModel> createArticle({
    required String title,
    required String text,
    required List<String> tags,
    required String difficulty,
  });

  Future<void> updateArticle({
    required int articleId,
    required String title,
    required String text,
    required List<String> tags,
    required String difficulty,
  });

  Future<void> deleteArticle(int articleId);
}