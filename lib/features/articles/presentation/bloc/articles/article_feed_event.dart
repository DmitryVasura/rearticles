import 'package:equatable/equatable.dart';

sealed class ArticleFeedEvent extends Equatable {
  const ArticleFeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadArticles extends ArticleFeedEvent {
  const LoadArticles();
}

class LoadMoreArticles extends ArticleFeedEvent {
  const LoadMoreArticles();
}
class LikeArticleEvent extends ArticleFeedEvent {
  final int articleId;

  const LikeArticleEvent({
    required this.articleId,
  });

  @override
  List<Object?> get props => [articleId];
}

class DeleteArticleEvent extends ArticleFeedEvent {
  final int articleId;

  const DeleteArticleEvent({required this.articleId});
}

class HideArticleEvent extends ArticleFeedEvent {
  final int articleId;

  const HideArticleEvent({required this.articleId});
}

class RestoreHiddenArticleEvent extends ArticleFeedEvent {
  const RestoreHiddenArticleEvent();
}