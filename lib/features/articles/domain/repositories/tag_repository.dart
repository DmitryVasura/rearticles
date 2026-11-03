import 'package:re_articles/features/articles/domain/entities/tag.dart';

abstract interface class TagRepository {
  Future<List<Tag>> getTags({String query = ''});
  Future<Tag> createTag(String name);
}