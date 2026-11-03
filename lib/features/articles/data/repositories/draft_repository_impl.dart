import 'package:re_articles/features/articles/data/datasources/local_draft_storage.dart';
import 'package:re_articles/features/articles/data/models/article_draft_model.dart';
import 'package:re_articles/features/articles/domain/entities/article_draft.dart';
import 'package:re_articles/features/articles/domain/repositories/draft_repository.dart';

class DraftRepositoryImpl implements DraftRepository {
  final LocalDraftStorage storage;

  const DraftRepositoryImpl(this.storage);

  @override
  Future<void> save(ArticleDraft draft) {
    return storage.save(
      ArticleDraftModel.fromEntity(draft),
    );
  }

  @override
  Future<ArticleDraft?> getById(String id) async {
    return storage.getById(id);
  }

  @override
  Future<List<ArticleDraft>> getAll() async {
    return storage.getAll();
  }

  @override
  Future<void> delete(String id) {
    return storage.delete(id);
  }
}