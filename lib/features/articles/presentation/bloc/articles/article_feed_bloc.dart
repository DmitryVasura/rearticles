import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/features/articles/data/models/article_model.dart';
import 'package:re_articles/features/articles/domain/entities/article_scope.dart';
import 'package:re_articles/features/articles/domain/usecases/delete_article.dart';
import 'package:re_articles/features/articles/domain/usecases/get_articles.dart';
import 'package:re_articles/features/articles/domain/usecases/like_article.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_state.dart';

class ArticleFeedBloc extends Bloc<ArticleFeedEvent, ArticleFeedState> {
  final GetArticles getArticles;
  final LikeArticle likeArticle;
  final DeleteArticle deleteArticle;

  static const int _pageSize = 10;

  int _offset = 0;
  bool _isLoadingMore = false;

  final _likesInFlight = <int>{};
  final ArticleScope scope;
  final int? authorId;

  ({ArticleModel article, int index})? _lastHidden;

  ArticleFeedBloc(
    this.getArticles,
    this.likeArticle,
    this.deleteArticle, {
    this.scope = ArticleScope.all,
    this.authorId,
  }) : super(const ArticleFeedInitial()) {
    on<LoadArticles>(_onLoadArticles);
    on<LoadMoreArticles>(_onLoadMoreArticles);
    on<LikeArticleEvent>(_onLikeArticle);
    on<DeleteArticleEvent>(_onDeleteArticle);
    on<HideArticleEvent>(_onHideArticle);
    on<RestoreHiddenArticleEvent>(_onRestoreHidden);
  }

  Future<void> _onLoadArticles(
    LoadArticles event,
    Emitter<ArticleFeedState> emit,
  ) async {
    _offset = 0;

    emit(const ArticleFeedLoading());

    try {
      final result = await getArticles(
        offset: 0,
        limit: _pageSize,
        scope: scope,
        authorId: authorId,
      );

      _offset = result.articles.length;

      emit(
        ArticleFeedLoaded(
          articles: result.articles,
          hasMore: _offset < result.total,
        ),
      );
    } catch (e) {
      emit(ArticleFeedError(e.toString()));
    }
  }

  Future<void> _onLoadMoreArticles(
    LoadMoreArticles event,
    Emitter<ArticleFeedState> emit,
  ) async {
    final currentState = state;

    if (currentState is! ArticleFeedLoaded) {
      return;
    }

    if (!currentState.hasMore) {
      return;
    }

    if (_isLoadingMore) {
      return;
    }

    _isLoadingMore = true;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final result = await getArticles(
        offset: _offset, 
        limit: _pageSize, 
        scope: scope,
        authorId: authorId,
      );

      final articles = [
        ...currentState.articles,
        ...result.articles,
      ];

      _offset += result.articles.length;

      emit(
        ArticleFeedLoaded(
          articles: articles,
          hasMore: _offset < result.total,
        ),
      );
    } catch (_) {
      emit(currentState.copyWith(isLoadingMore: false));
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> _onLikeArticle(
    LikeArticleEvent event,
    Emitter<ArticleFeedState> emit,
  ) async {
    if (!_likesInFlight.add(event.articleId)) return;

    try {
      final currentState = state;

      if (currentState is! ArticleFeedLoaded) {
        return;
      }

      final index = currentState.articles.indexWhere(
        (article) => article.id == event.articleId,
      );

      if (index == -1) {
        return;
      }

      final article = currentState.articles[index];
      final liked = !article.likedByMe;

      final updatedArticles = [...currentState.articles];
      updatedArticles[index] = article.copyWith(
        likedByMe: liked,
        likes: article.likes + (liked ? 1 : -1),
      );

      emit(currentState.copyWith(articles: updatedArticles));

      try {
        await likeArticle(
          articleId: event.articleId,
          liked: liked,
        );
      } catch (_) {
        final latest = state;

        if (latest is ArticleFeedLoaded) {
          final i = latest.articles.indexWhere(
            (a) => a.id == event.articleId,
          );

          if (i != -1) {
            final reverted = [...latest.articles];
            reverted[i] = article;

            emit(latest.copyWith(articles: reverted));
          }
        }
      }
    } finally {
      _likesInFlight.remove(event.articleId);
    }
  }
  Future<void> _onDeleteArticle(
    DeleteArticleEvent event,
    Emitter<ArticleFeedState> emit,
  ) async {
    final currentState = state;

    if (currentState is! ArticleFeedLoaded) return;

    final index = currentState.articles.indexWhere(
      (article) => article.id == event.articleId,
    );

    if (index == -1) return;

    final article = currentState.articles[index];

    _offset -= 1;
    emit(
      currentState.copyWith(
        articles: [...currentState.articles]..removeAt(index),
      ),
    );

    try {
      await deleteArticle(articleId: event.articleId);
    } catch (_) {
      _offset += 1;

      final latest = state;

      if (latest is ArticleFeedLoaded) {
        final restored = [...latest.articles];
        final at = index > restored.length ? restored.length : index;
        restored.insert(at, article);

        emit(latest.copyWith(articles: restored));
      }
    }
  }

  void _onHideArticle(
    HideArticleEvent event,
    Emitter<ArticleFeedState> emit,
  ) {
    final current = state;

    if (current is! ArticleFeedLoaded) return;

    final index = current.articles.indexWhere(
      (article) => article.id == event.articleId,
    );

    if (index == -1) return;

    _lastHidden = (article: current.articles[index], index: index);
    _offset -= 1;

    emit(
      current.copyWith(
        articles: [...current.articles]..removeAt(index),
      ),
    );
  }

  void _onRestoreHidden(
    RestoreHiddenArticleEvent event,
    Emitter<ArticleFeedState> emit,
  ) {
    final hidden = _lastHidden;
    final current = state;

    if (hidden == null || current is! ArticleFeedLoaded) return;

    _lastHidden = null;
    _offset += 1;

    final restored = [...current.articles];
    final at = hidden.index > restored.length ? restored.length : hidden.index;
    restored.insert(at, hidden.article);

    emit(current.copyWith(articles: restored));
  }
}