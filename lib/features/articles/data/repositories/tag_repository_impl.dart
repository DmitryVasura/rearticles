import 'package:re_articles/features/articles/data/datasources/tag_api.dart';
import 'package:re_articles/features/articles/domain/entities/tag.dart';
import 'package:re_articles/features/articles/domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final TagApi tagApi;

  const TagRepositoryImpl(this.tagApi);

  @override
  Future<List<Tag>> getTags({String query = ''}) {
    return tagApi.getTags(query: query);
  }
  
  @override
  Future<Tag> createTag(String name) => tagApi.createTag(name);
}