import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:re_articles/features/articles/data/models/article_draft_model.dart';
import 'package:re_articles/features/articles/domain/entities/article_draft.dart';

final _updatedAt = DateTime(2026, 1, 1);

ArticleDraft makeDraft({
  String title = '',
  List<dynamic>? content,
  int? articleId,
  List<String> tags = const [],
  String? difficulty,
}) {
  return ArticleDraft(
    id: 'draft-1',
    title: title,
    content: content ??
        [
          {'insert': '\n'},
        ],
    updatedAt: _updatedAt,
    articleId: articleId,
    tags: tags,
    difficulty: difficulty,
  );
}

void main() {
  group('ArticleDraft.plainText', () {
    test('склеивает текстовые вставки и обрезает пробелы', () {
      final draft = makeDraft(
        content: [
          {'insert': '  Hello '},
          {'insert': 'world\n'},
        ],
      );

      expect(draft.plainText, 'Hello world');
    });

    test('игнорирует вставки-картинки', () {
      final draft = makeDraft(
        content: [
          {'insert': 'a'},
          {
            'insert': {'image': 'x'},
          },
          {'insert': 'b\n'},
        ],
      );

      expect(draft.plainText, 'ab');
    });
  });

  group('ArticleDraft.isEmpty', () {
    test('пустой документ без названия пуст', () {
      expect(makeDraft().isEmpty, true);
    });

    test('название из одних пробелов считается пустым', () {
      expect(makeDraft(title: '   ').isEmpty, true);
    });

    test('с названием не пуст', () {
      expect(makeDraft(title: 'Hi').isEmpty, false);
    });

    test('с текстом не пуст', () {
      final draft = makeDraft(
        content: [
          {'insert': 'text\n'},
        ],
      );

      expect(draft.isEmpty, false);
    });

    test('с одной картинкой не пуст', () {
      final draft = makeDraft(
        content: [
          {
            'insert': {'image': 'x'},
          },
          {'insert': '\n'},
        ],
      );

      expect(draft.isEmpty, false);
    });
  });

  group('ArticleDraft.copyWith', () {
    test('меняет название, текст и время, остальное сохраняет', () {
      final original = makeDraft(
        articleId: 5,
        tags: const ['rust'],
        difficulty: 'hard',
      );

      final copy = original.copyWith(
        title: 'New',
        content: [
          {'insert': 'x\n'},
        ],
        updatedAt: DateTime(2027, 1, 1),
      );

      expect(copy.id, original.id);
      expect(copy.title, 'New');
      expect(copy.plainText, 'x');
      expect(copy.updatedAt, DateTime(2027, 1, 1));
      expect(copy.articleId, 5);
      expect(copy.tags, ['rust']);
      expect(copy.difficulty, 'hard');
    });
  });

  group('ArticleDraft.toArticle', () {
    test('собирает данные для страницы публикации', () {
      final draft = makeDraft(
        title: '  Title  ',
        content: [
          {'insert': 'text\n'},
        ],
        articleId: 9,
        tags: const ['rust', 'web'],
        difficulty: 'hard',
      );

      final article = draft.toArticle();

      expect(article['title'], 'Title');
      expect(article['draftId'], 'draft-1');
      expect(article['articleId'], 9);
      expect(article['tags'], ['rust', 'web']);
      expect(article['difficulty'], 'hard');
      expect(article['likes'], 0);
      expect(article['views'], 0);
      expect(jsonDecode(article['text'] as String), draft.content);
    });

    test('у новой статьи нет articleId', () {
      expect(makeDraft().toArticle()['articleId'], isNull);
    });
  });

  group('ArticleDraftModel', () {
    test('encode и decode сохраняют все поля', () {
      final model = ArticleDraftModel.fromEntity(
        makeDraft(
          title: 'T',
          content: [
            {'insert': 'x\n'},
          ],
          articleId: 4,
          tags: const ['rust'],
          difficulty: 'hard',
        ),
      );

      final restored = ArticleDraftModel.decode(model.encode());

      expect(restored.id, 'draft-1');
      expect(restored.title, 'T');
      expect(restored.content, model.content);
      expect(restored.updatedAt, _updatedAt);
      expect(restored.articleId, 4);
      expect(restored.tags, ['rust']);
      expect(restored.difficulty, 'hard');
    });

    test('старый черновик без новых полей читается со значениями по умолчанию', () {
      final restored = ArticleDraftModel.fromJson({
        'id': 'old',
        'title': 'Old',
        'content': [
          {'insert': 'x\n'},
        ],
        'updatedAt': _updatedAt.toIso8601String(),
      });

      expect(restored.articleId, isNull);
      expect(restored.tags, isEmpty);
      expect(restored.difficulty, isNull);
    });

    test('отсутствующие название и текст не вызывают ошибку', () {
      final restored = ArticleDraftModel.fromJson({
        'id': 'x',
        'updatedAt': _updatedAt.toIso8601String(),
      });

      expect(restored.title, '');
      expect(restored.content, isEmpty);
    });
  });
}
