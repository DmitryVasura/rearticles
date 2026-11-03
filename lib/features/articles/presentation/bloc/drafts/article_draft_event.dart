import 'package:re_articles/features/articles/domain/entities/article_draft.dart';

abstract class ArticleDraftEvent {
  const ArticleDraftEvent();
}

class LoadDraft extends ArticleDraftEvent {
  final String? id;

  const LoadDraft({this.id});
}

class LoadDrafts extends ArticleDraftEvent {
  const LoadDrafts();
}

class DraftChanged extends ArticleDraftEvent {
  final String id;
  final String title;
  final List<dynamic> content;

  const DraftChanged({
    required this.id,
    required this.title,
    required this.content,
  });
}

class DeleteDraft extends ArticleDraftEvent {
  final String id;

  const DeleteDraft(this.id);
}

class SaveDraftImmediately extends ArticleDraftEvent {
  final ArticleDraft draft;

  const SaveDraftImmediately(this.draft);
}