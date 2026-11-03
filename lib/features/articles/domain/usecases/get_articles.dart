import 'package:re_articles/features/articles/data/models/articles_response_model.dart';
import 'package:re_articles/features/articles/domain/entities/article_scope.dart';
import 'package:re_articles/features/articles/domain/repositories/article_repository.dart';

class GetArticles {
  final ArticleRepository repository;

  const GetArticles(this.repository);

  Future<ArticlesResponseModel> call({
    required int offset,
    required int limit,
    ArticleScope scope = ArticleScope.all,
    int? authorId,
  }) {
    return repository.getArticles(
      offset: offset,
      limit: limit,
      scope: scope,
      authorId: authorId
    );
  }
}