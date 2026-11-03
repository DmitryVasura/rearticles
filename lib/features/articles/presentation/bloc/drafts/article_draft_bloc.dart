import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/features/articles/domain/entities/article_draft.dart';
import 'package:re_articles/features/articles/domain/repositories/draft_repository.dart';
import 'package:re_articles/features/articles/presentation/bloc/drafts/article_draft_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/drafts/article_draft_state.dart';

class ArticleDraftBloc
    extends Bloc<ArticleDraftEvent, ArticleDraftState> {
  final DraftRepository repository;

  Timer? _saveTimer;
  ArticleDraft? _pendingDraft;

  ArticleDraftBloc(this.repository)
      : super(const ArticleDraftInitial()) {
    on<LoadDraft>(_onLoadDraft);
    on<LoadDrafts>(_onLoadDrafts);
    on<DraftChanged>(_onDraftChanged);
    on<SaveDraftImmediately>(_onSaveImmediately);
    on<DeleteDraft>(_onDeleteDraft);
  }

  /// Пустой черновик удаляем, непустой сохраняем.
  Future<void> _persist(ArticleDraft draft) {
    return draft.isEmpty
        ? repository.delete(draft.id)
        : repository.save(draft);
  }

  Future<void> _onLoadDraft(
    LoadDraft event,
    Emitter<ArticleDraftState> emit,
  ) async {
    emit(const ArticleDraftLoading());

    try {
      final existing = event.id == null
          ? null
          : await repository.getById(event.id!);

      final draft = existing ??
          ArticleDraft(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: '',
            content: [
              {'insert': '\n'},
            ],
            updatedAt: DateTime.now(),
          );

      emit(ArticleDraftLoaded(draft: draft));
    } catch (error) {
      emit(ArticleDraftError(error.toString()));
    }
  }

  Future<void> _onLoadDrafts(
    LoadDrafts event,
    Emitter<ArticleDraftState> emit,
  ) async {
    emit(const ArticleDraftLoading());

    try {
      final drafts = await repository.getAll();

      emit(ArticleDraftsLoaded(drafts: drafts));
    } catch (error) {
      emit(ArticleDraftError(error.toString()));
    }
  }

  void _onDraftChanged(
    DraftChanged event,
    Emitter<ArticleDraftState> emit,
  ) {
    final currentState = state;

    if (currentState is! ArticleDraftLoaded) {
      return;
    }

    final draft = currentState.draft.copyWith(
      title: event.title,
      content: event.content,
      updatedAt: DateTime.now(),
    );

    _pendingDraft = draft;

    emit(
      ArticleDraftLoaded(
        draft: draft,
        isSaving: true,
      ),
    );

    _saveTimer?.cancel();

    _saveTimer = Timer(
      const Duration(milliseconds: 700),
      () {
        if (!isClosed) {
          add(SaveDraftImmediately(draft));
        }
      },
    );
  }

  Future<void> _onSaveImmediately(
    SaveDraftImmediately event,
    Emitter<ArticleDraftState> emit,
  ) async {
    _saveTimer?.cancel();

    try {
      await _persist(event.draft);

      if (isClosed) return;

      final latestState = state;

      if (latestState is ArticleDraftLoaded &&
          latestState.draft.id == event.draft.id) {
        emit(latestState.copyWith(isSaving: false));
      }

      if (_pendingDraft?.id == event.draft.id) {
        _pendingDraft = null;
      }
    } catch (error) {
      if (isClosed) return;

      emit(ArticleDraftError(error.toString()));
    }
  }

  Future<void> _onDeleteDraft(
    DeleteDraft event,
    Emitter<ArticleDraftState> emit,
  ) async {
    _saveTimer?.cancel();

    final current = state;
    if (current is ArticleDraftsLoaded) {
      emit(
        ArticleDraftsLoaded(
          drafts: current.drafts.where((d) => d.id != event.id).toList(),
        ),
      );
    }

    try {
      await repository.delete(event.id);

      if (_pendingDraft?.id == event.id) _pendingDraft = null;

      if (current is! ArticleDraftsLoaded) {
        emit(const ArticleDraftInitial());
      }
    } catch (error) {
      emit(ArticleDraftError(error.toString()));
    }
  }

  @override
  Future<void> close() async {
    _saveTimer?.cancel();

    final pending = _pendingDraft;

    if (pending != null) {
      try {
        await _persist(pending); 
      } catch (_) {
      }
    }

    await super.close();
  }
}