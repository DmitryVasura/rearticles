import 'package:re_articles/features/articles/domain/entities/article_draft.dart';

abstract interface class DraftRepository {
  Future<void> save(ArticleDraft draft);

  Future<ArticleDraft?> getById(String id);

  Future<List<ArticleDraft>> getAll();

  Future<void> delete(String id);
}