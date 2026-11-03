import 'package:re_articles/features/articles/data/models/article_model.dart';

/// Статья для тестов. Лишние поля задаются только когда они нужны.
ArticleModel makeArticle(
  int id, {
  int likes = 0,
  bool likedByMe = false,
  int? authorId,
}) {
  return ArticleModel(
    id: id,
    title: 'Article $id',
    text: '[{"insert":"text\\n"}]',
    preview: 'text',
    likes: likes,
    views: 0,
    difficulty: 'normal',
    tags: const [],
    authorId: authorId,
    likedByMe: likedByMe,
  );
}
