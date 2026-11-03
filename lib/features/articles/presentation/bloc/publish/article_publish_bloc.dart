import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/features/articles/domain/repositories/draft_repository.dart';
import 'package:re_articles/features/articles/domain/usecases/publish_article.dart';
import 'package:re_articles/features/articles/domain/usecases/update_article.dart';
import 'package:re_articles/features/articles/presentation/bloc/publish/article_publish_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/publish/article_publish_state.dart';

class ArticlePublishBloc extends Bloc<ArticlePublishEvent, ArticlePublishState> {
  final PublishArticle publishArticle;
  final UpdateArticle updateArticle;
  final DraftRepository draftRepository;

  ArticlePublishBloc(
    this.publishArticle,
    this.updateArticle,
    this.draftRepository,
  ) : super(const ArticlePublishInitial()) {
    on<PublishArticleRequested>(_onPublish);
  }

  Future<void> _onPublish(
    PublishArticleRequested event,
    Emitter<ArticlePublishState> emit,
  ) async {
    if (state is ArticlePublishing) return;

    emit(const ArticlePublishing());

    try {
      final articleId = event.articleId;

      if (articleId == null) {
        await publishArticle(
          title: event.title,
          text: event.text,
          tags: event.tags,
          difficulty: event.difficulty,
        );
      } else {
        await updateArticle(
          articleId: articleId,
          title: event.title,
          text: event.text,
          tags: event.tags,
          difficulty: event.difficulty,
        );
      }
    } catch (e) {
      debugPrint('Publish failed: $e');
      emit(const ArticlePublishFailure(
        'Failed to save the article. Please try again.',
      ));
      return;
    }

    final draftId = event.draftId;
    if (draftId != null) {
      try {
        await draftRepository.delete(draftId);
      } catch (_) {}
    }

    emit(const ArticlePublished());
  }
}