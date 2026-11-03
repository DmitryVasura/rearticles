import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/features/articles/domain/repositories/tag_repository.dart';
import 'package:re_articles/features/articles/presentation/bloc/tags/tag_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/tags/tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  final TagRepository tagRepository;

  TagBloc(this.tagRepository) : super(const TagsInitial()) {
    on<LoadTags>(_onLoadTags);
    on<SearchTags>(_onSearchTags);
    on<CreateTag>(_onCreateTag);
  }

  Future<void> _onLoadTags(
    LoadTags event,
    Emitter<TagState> emit,
  ) async {
    emit(const TagsLoading());

    try {
      final tags = await tagRepository.getTags();
      emit(TagsLoaded(tags));
    } catch (e) {
      emit(TagsError(e.toString()));
    }
  }

  Future<void> _onSearchTags(
    SearchTags event,
    Emitter<TagState> emit,
  ) async {
    emit(const TagsLoading());

    try {
      final tags = await tagRepository.getTags(query: event.query);
      emit(TagsLoaded(tags));
    } catch (e) {
      emit(TagsError(e.toString()));
    }
  }

  Future<void> _onCreateTag(
    CreateTag event,
    Emitter<TagState> emit,
  ) async {
    final current = state;
    if (current is! TagsLoaded) return;

    try {
      final tag = await tagRepository.createTag(event.name);
      final tags = current.tags.any((t) => t.id == tag.id)
          ? current.tags
          : [...current.tags, tag];

      // Сначала «чистое» состояние, чтобы повторное создание того же тега
      // тоже вызвало слушателя (одинаковые состояния bloc игнорирует).
      emit(TagsLoaded(tags));
      emit(TagsLoaded(tags, created: tag));
    } catch (_) {
      emit(TagsLoaded(current.tags));
      emit(TagsLoaded(current.tags, error: 'Failed to create tag'));
    }
  }
}