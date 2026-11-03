import 'package:hive/hive.dart';
import 'package:re_articles/features/articles/data/models/article_draft_model.dart';

class LocalDraftStorage {
  final Box<String> box;

  const LocalDraftStorage(this.box);

  Future<void> save(ArticleDraftModel draft) async {
    await box.put(draft.id, draft.encode());
  }

  ArticleDraftModel? getById(String id) {
    final value = box.get(id);

    if (value == null) {
      return null;
    }

    return ArticleDraftModel.decode(value);
  }

  List<ArticleDraftModel> getAll() {
    return box.values
        .map(ArticleDraftModel.decode)
        .toList()
      ..sort(
        (a, b) => b.updatedAt.compareTo(a.updatedAt),
      );
  }

  Future<void> delete(String id) {
    return box.delete(id);
  }
}