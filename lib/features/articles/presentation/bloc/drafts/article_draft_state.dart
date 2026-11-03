import 'package:re_articles/features/articles/domain/entities/article_draft.dart';

abstract class ArticleDraftState {
  const ArticleDraftState();
}

class ArticleDraftInitial extends ArticleDraftState {
  const ArticleDraftInitial();
}

class ArticleDraftLoading extends ArticleDraftState {
  const ArticleDraftLoading();
}

class ArticleDraftLoaded extends ArticleDraftState {
  final ArticleDraft draft;
  final bool isSaving;

  const ArticleDraftLoaded({
    required this.draft,
    this.isSaving = false,
  });

  ArticleDraftLoaded copyWith({
    ArticleDraft? draft,
    bool? isSaving,
  }) {
    return ArticleDraftLoaded(
      draft: draft ?? this.draft,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class ArticleDraftsLoaded extends ArticleDraftState {
  final List<ArticleDraft> drafts;

  const ArticleDraftsLoaded({
    required this.drafts,
  });
}

class ArticleDraftError extends ArticleDraftState {
  final String message;

  const ArticleDraftError(this.message);
}