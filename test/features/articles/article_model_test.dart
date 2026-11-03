import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:re_articles/features/articles/data/models/article_model.dart';
import 'package:re_articles/features/articles/data/models/articles_response_model.dart';
import 'package:re_articles/features/articles/data/models/tag_model.dart';
import 'package:re_articles/features/articles/presentation/widgets/difficulty_widget.dart';

Map<String, dynamic> json({Object? text, Map<String, dynamic>? extra}) {
  return {
    'id': 1,
    'title': 'Title',
    'text': text ?? [
      {'insert': 'Hello\n'},
    ],
    ...?extra,
  };
}

void main() {
  group('ArticleModel.fromJson', () {
    test('текст-массив (Delta) превращается в JSON-строку', () {
      final delta = [
        {'insert': 'Hello\n'},
      ];

      final article = ArticleModel.fromJson(json(text: delta));

      expect(article.text, jsonEncode(delta));
    });

    test('текст-строка остаётся как есть', () {
      final article = ArticleModel.fromJson(json(text: '[{"insert":"x\\n"}]'));

      expect(article.text, '[{"insert":"x\\n"}]');
    });

    test('значения по умолчанию', () {
      final article = ArticleModel.fromJson(json());

      expect(article.likes, 0);
      expect(article.views, 0);
      expect(article.difficulty, 'normal');
      expect(article.likedByMe, false);
      expect(article.tags, isEmpty);
      expect(article.authorId, isNull);
      expect(article.authorName, isNull);
    });

    test('читает автора, лайки, просмотры и сложность', () {
      final article = ArticleModel.fromJson(
        json(
          extra: {
            'likes': 5,
            'views': 9,
            'difficulty': 'hard',
            'likedByMe': true,
            'author': {'id': 7, 'username': 'alice'},
          },
        ),
      );

      expect(article.likes, 5);
      expect(article.views, 9);
      expect(article.difficulty, 'hard');
      expect(article.likedByMe, true);
      expect(article.authorId, 7);
      expect(article.authorName, 'alice');
    });

    test('теги принимаются и строками, и объектами', () {
      final article = ArticleModel.fromJson(
        json(
          extra: {
            'tags': [
              'rust',
              {'tag': 'web'},
            ],
          },
        ),
      );

      expect(article.tags.map((tag) => tag.tag), ['rust', 'web']);
    });

    test('неверный формат тега вызывает FormatException', () {
      expect(() => TagModel.fromJson(42), throwsFormatException);
    });
  });

  group('ArticleModel.preview', () {
    String previewOf(Object text) =>
        ArticleModel.fromJson(json(text: text)).preview;

    test('склеивает текстовые вставки и обрезает пробелы', () {
      expect(
        previewOf([
          {'insert': 'Hello '},
          {'insert': 'world\n'},
        ]),
        'Hello world',
      );
    });

    test('пропускает вставки-картинки', () {
      expect(
        previewOf([
          {'insert': 'Before '},
          {
            'insert': {'image': 'http://x/y.png'},
          },
          {'insert': 'after\n'},
        ]),
        'Before after',
      );
    });

    test('обычная строка (не JSON) возвращается без изменений', () {
      expect(previewOf('just plain text'), 'just plain text');
    });

    test('JSON, который не список, возвращается как есть', () {
      expect(previewOf('123'), '123');
    });
  });

  group('ArticleModel.copyWith', () {
    test('меняет лайки и отметку, остальное сохраняет', () {
      final original = ArticleModel.fromJson(
        json(
          extra: {
            'likes': 1,
            'views': 4,
            'difficulty': 'hard',
            'tags': ['rust'],
            'author': {'id': 3, 'username': 'bob'},
          },
        ),
      );

      final copy = original.copyWith(likes: 2, likedByMe: true);

      expect(copy.likes, 2);
      expect(copy.likedByMe, true);
      expect(copy.id, original.id);
      expect(copy.title, original.title);
      expect(copy.text, original.text);
      expect(copy.preview, original.preview);
      expect(copy.views, 4);
      expect(copy.difficulty, 'hard');
      expect(copy.authorName, 'bob');
      expect(copy.tags.single.tag, 'rust');
    });

    test('без аргументов ничего не меняет', () {
      final original = ArticleModel.fromJson(json(extra: {'likes': 3}));
      final copy = original.copyWith();

      expect(copy.likes, 3);
      expect(copy.likedByMe, false);
    });
  });

  group('ArticlesResponseModel.fromJson', () {
    test('разбирает страницу статей и пагинацию', () {
      final response = ArticlesResponseModel.fromJson({
        'articles': [json(), json(extra: {'id': 2})],
        'offset': 10,
        'limit': 5,
        'total': 42,
      });

      expect(response.articles.length, 2);
      expect(response.offset, 10);
      expect(response.limit, 5);
      expect(response.total, 42);
    });

    test('пустой ответ не падает', () {
      final response = ArticlesResponseModel.fromJson({});

      expect(response.articles, isEmpty);
      expect(response.total, 0);
    });
  });

  group('ArticleDifficality', () {
    test('fromName находит значение по имени', () {
      expect(ArticleDifficality.fromName('hard'), ArticleDifficality.hard);
      expect(
        ArticleDifficality.fromName('advanced'),
        ArticleDifficality.advanced,
      );
    });

    test('неизвестное или пустое имя даёт normal', () {
      expect(ArticleDifficality.fromName(null), ArticleDifficality.normal);
      expect(ArticleDifficality.fromName('???'), ArticleDifficality.normal);
    });

    // test('label начинается с заглавной буквы', () {
    //   expect(ArticleDifficality.easy.label, 'Easy');
    //   expect(ArticleDifficality.advanced.label, 'Advanced');
    // });
  });
}
