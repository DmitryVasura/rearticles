import 'package:equatable/equatable.dart';
import 'package:re_articles/features/articles/data/models/article_model.dart';

sealed class ArticleFeedState extends Equatable {
  const ArticleFeedState();

  @override
  List<Object?> get props => [];
}

class ArticleFeedInitial extends ArticleFeedState {
  const ArticleFeedInitial();
}

class ArticleFeedLoading extends ArticleFeedState {
  const ArticleFeedLoading();
}

class ArticleFeedLoaded extends ArticleFeedState {
  final List<ArticleModel> articles;
  final bool hasMore;
  final bool isLoadingMore;

  const ArticleFeedLoaded({
    required this.articles,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  ArticleFeedLoaded copyWith({
    List<ArticleModel>? articles,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ArticleFeedLoaded(
      articles: articles ?? this.articles,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        articles,
        hasMore,
        isLoadingMore,
      ];
}

class ArticleFeedError extends ArticleFeedState {
  final String message;

  const ArticleFeedError(this.message);

  @override
  List<Object?> get props => [message];
}