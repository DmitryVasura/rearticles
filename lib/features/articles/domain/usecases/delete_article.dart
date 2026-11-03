import 'package:re_articles/features/articles/domain/repositories/article_repository.dart';

class DeleteArticle {
  final ArticleRepository repository;

  const DeleteArticle(this.repository);

  Future<void> call({required int articleId}) {
    return repository.deleteArticle(articleId);
  }
}