sealed class ArticlePublishState {
  const ArticlePublishState();
}

final class ArticlePublishInitial extends ArticlePublishState {
  const ArticlePublishInitial();
}

final class ArticlePublishing extends ArticlePublishState {
  const ArticlePublishing();
}

final class ArticlePublished extends ArticlePublishState {
  const ArticlePublished();
}

final class ArticlePublishFailure extends ArticlePublishState {
  final String message;

  const ArticlePublishFailure(this.message);
}