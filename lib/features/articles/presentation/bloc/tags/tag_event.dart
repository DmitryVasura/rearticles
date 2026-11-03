import 'package:equatable/equatable.dart';

sealed class TagEvent extends Equatable {
  const TagEvent();

  @override
  List<Object?> get props => [];
}

final class LoadTags extends TagEvent {
  const LoadTags();
}

final class SearchTags extends TagEvent {
  final String query;

  const SearchTags(this.query);

  @override
  List<Object?> get props => [query];
}

final class CreateTag extends TagEvent {
  final String name;

  const CreateTag(this.name);

  @override
  List<Object?> get props => [name];
}