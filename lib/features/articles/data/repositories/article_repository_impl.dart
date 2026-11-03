import 'package:re_articles/features/articles/data/datasources/article_api.dart';
import 'package:re_articles/features/articles/data/models/article_model.dart';
import 'package:re_articles/features/articles/data/models/articles_response_model.dart';
import 'package:re_articles/features/articles/domain/entities/article_scope.dart';
import 'package:re_articles/features/articles/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleApi api;

  ArticleRepositoryImpl(this.api);

  @override
  Future<ArticlesResponseModel> getArticles({
    required int offset,
    required int limit,
    ArticleScope scope = ArticleScope.all,
    int? authorId,
  }) {
    return api.getArticles(
      offset: offset,
      limit: limit,
      scope: scope,
      authorId: authorId
    );
  }
  
  @override
  Future<void> likeArticle({
    required int articleId,
    required bool liked,
  }) {
    return api.setLike(articleId: articleId, liked: liked);
  }
  
  @override
  Future<ArticleModel> createArticle({
    required String title,
    required String text,
    required List<String> tags,
    required String difficulty,
  }) {
    return api.createArticle(
      title: title,
      text: text,
      tags: tags,
      difficulty: difficulty,
    );
  }
  @override
  Future<void> updateArticle({
    required int articleId,
    required String title,
    required String text,
    required List<String> tags,
    required String difficulty,
  }) {
    return api.updateArticle(
      articleId: articleId,
      title: title,
      text: text,
      tags: tags,
      difficulty: difficulty,
    );
  }

  @override
  Future<void> deleteArticle(int articleId) {
    return api.deleteArticle(articleId);
  }
}