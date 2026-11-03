import 'package:dio/dio.dart';
import 'package:re_articles/features/articles/domain/entities/tag.dart';

class TagApi {
  final Dio dio;

  const TagApi(this.dio);

  Future<List<Tag>> getTags({String query = ''}) async {
    final response = await dio.get(
      '/tags',
      queryParameters: {
        if (query.trim().isNotEmpty) 'q': query.trim(),
      },
    );

    final data = response.data as Map<String, dynamic>;
    final tags = data['tags'] as List<dynamic>;

    return tags
        .map(
          (tag) => Tag.fromJson(
            Map<String, dynamic>.from(tag as Map),
          ),
        )
        .toList();
  }

  Future<Tag> createTag(String name) async {
    try {
      final response = await dio.post('/tags', data: {'name': name.trim()});
      return Tag.fromJson(Map<String, dynamic>.from(response.data as Map));
    } on DioException catch (e) {
      // 409 = такой тег уже есть, сервер присылает его в поле "tag".
      // Для нас это не ошибка: просто используем существующий.
      if (e.response?.statusCode == 409) {
        final data = e.response!.data as Map;
        return Tag.fromJson(Map<String, dynamic>.from(data['tag'] as Map));
      }
      rethrow;
    }
  }
}