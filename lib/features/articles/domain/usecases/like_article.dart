import 'package:re_articles/features/articles/domain/repositories/article_repository.dart';

class LikeArticle {
  final ArticleRepository repository;

  const LikeArticle(this.repository);

  Future<void> call({
    required int articleId,
    required bool liked,
  }) {
    return repository.likeArticle(
      articleId: articleId,
      liked: liked,
    );
  }
}