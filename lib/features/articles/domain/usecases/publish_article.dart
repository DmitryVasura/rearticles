import 'package:re_articles/features/articles/data/models/article_model.dart';
import 'package:re_articles/features/articles/domain/repositories/article_repository.dart';

class PublishArticle {
  final ArticleRepository repository;

  const PublishArticle(this.repository);

  Future<ArticleModel> call({
    required String title,
    required String text,
    required List<String> tags,
    required String difficulty,
  }) {
    return repository.createArticle(
      title: title,
      text: text,
      tags: tags,
      difficulty: difficulty,
    );
  }
}