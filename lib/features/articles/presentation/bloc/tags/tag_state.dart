import 'package:equatable/equatable.dart';
import 'package:re_articles/features/articles/domain/entities/tag.dart';

sealed class TagState extends Equatable {
  const TagState();

  @override
  List<Object?> get props => [];
}

final class TagsInitial extends TagState {
  const TagsInitial();
}

final class TagsLoading extends TagState {
  const TagsLoading();
}

final class TagsLoaded extends TagState {
  final List<Tag> tags;
  final Tag? created;
  final String? error;

  const TagsLoaded(this.tags, {this.created, this.error});

  @override
  List<Object?> get props => [tags, created, error];
}

final class TagsError extends TagState {
  final String message;

  const TagsError(this.message);

  @override
  List<Object?> get props => [message];
}