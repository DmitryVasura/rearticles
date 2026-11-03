sealed class ArticlePublishEvent {
  const ArticlePublishEvent();
}

final class PublishArticleRequested extends ArticlePublishEvent {
  final String title;
  final String text;
  final List<String> tags;
  final String difficulty;
  final String? draftId;

  final int? articleId;

  const PublishArticleRequested({
    required this.title,
    required this.text,
    required this.tags,
    required this.difficulty,
    this.draftId,
    this.articleId,
  });
}