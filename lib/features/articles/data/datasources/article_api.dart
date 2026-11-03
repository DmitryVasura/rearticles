import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:re_articles/features/articles/data/models/article_model.dart';
import 'package:re_articles/features/articles/data/models/articles_response_model.dart';
import 'package:re_articles/features/articles/domain/entities/article_scope.dart';

class ArticleApi {
  final Dio dio;

  ArticleApi(this.dio);

  Future<ArticlesResponseModel> getArticles({
    required int offset,
    required int limit,
    ArticleScope scope = ArticleScope.all,
    int? authorId,
  }) async {
    final response = await dio.get(
      '/articles',
      queryParameters: {
        'offset': offset,
        'limit': limit,
        if (scope != ArticleScope.all) 'scope': scope.name,
        'authorId': ?authorId,
      },
    );

    return ArticlesResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> setLike({
    required int articleId,
    required bool liked,
  }) async {
    await dio.post(
      liked ? '/events/like' : '/events/unlike',
      data: {'articleId': articleId},
    );
  }

  Future<ArticleModel> createArticle({
    required String title,
    required String text,
    required List<String> tags,
    required String difficulty,
  }) async {
    final response = await dio.post(
      '/articles',
      data: {
        'title': title,
        'text': jsonDecode(text),
        'tags': tags,
        'difficulty': difficulty,
      },
    );

    return ArticleModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<void> trackOpen(int articleId) async {
    await dio.post(
      '/events/open',
      data: {'articleId': articleId},
    );
  }

  Future<void> trackRead(int articleId, double progress) async {
    await dio.post(
      '/events/read',
      data: {
        'articleId': articleId,
        'data': {'progress': progress},
      },
    );
  }

  static const _publishTimeout = Duration(seconds: 40);

  Future<void> updateArticle({
    required int articleId,
    required String title,
    required String text,
    required List<String> tags,
    required String difficulty,
  }) async {
    await dio.patch(
      '/articles/$articleId',
      data: {
        'title': title,
        'text': jsonDecode(text),
        'tags': tags,
        'difficulty': difficulty,
      },
      options: Options(
        sendTimeout: _publishTimeout,
        receiveTimeout: _publishTimeout,
      ),
    );
  }

  Future<void> deleteArticle(int articleId) async {
    await dio.delete('/articles/$articleId');
  }
  Future<void> setDislike({
    required int articleId,
    required bool disliked,
  }) async {
    await dio.post(
      disliked ? '/events/dislike' : '/events/undislike',
      data: {'articleId': articleId},
    );
  }

  Future<void> reportArticle({
    required int articleId,
    required String reason,
  }) async {
    await dio.post(
      '/reports',
      data: {'articleId': articleId, 'reason': reason},
    );
  }
}