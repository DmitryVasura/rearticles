import 'package:re_articles/features/articles/domain/repositories/article_repository.dart';

class UpdateArticle {
  final ArticleRepository repository;

  const UpdateArticle(this.repository);

  Future<void> call({
    required int articleId,
    required String title,
    required String text,
    required List<String> tags,
    required String difficulty,
  }) {
    return repository.updateArticle(
      articleId: articleId,
      title: title,
      text: text,
      tags: tags,
      difficulty: difficulty,
    );
  }
}