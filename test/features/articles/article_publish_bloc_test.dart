import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:re_articles/features/articles/data/models/article_model.dart';
import 'package:re_articles/features/articles/domain/repositories/draft_repository.dart';
import 'package:re_articles/features/articles/domain/usecases/publish_article.dart';
import 'package:re_articles/features/articles/domain/usecases/update_article.dart';
import 'package:re_articles/features/articles/presentation/bloc/publish/article_publish_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/publish/article_publish_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/publish/article_publish_state.dart';

import '../../helpers/fixtures.dart';

class MockPublishArticle extends Mock implements PublishArticle {}

class MockUpdateArticle extends Mock implements UpdateArticle {}

class MockDraftRepository extends Mock implements DraftRepository {}

const _title = 'Title';
const _text = '[{"insert":"x\\n"}]';
const _tags = ['rust'];
const _difficulty = 'hard';

PublishArticleRequested request({String? draftId, int? articleId}) {
  return PublishArticleRequested(
    title: _title,
    text: _text,
    tags: _tags,
    difficulty: _difficulty,
    draftId: draftId,
    articleId: articleId,
  );
}

void main() {
  late MockPublishArticle publishArticle;
  late MockUpdateArticle updateArticle;
  late MockDraftRepository draftRepository;

  setUp(() {
    publishArticle = MockPublishArticle();
    updateArticle = MockUpdateArticle();
    draftRepository = MockDraftRepository();
  });

  ArticlePublishBloc buildBloc() {
    return ArticlePublishBloc(publishArticle, updateArticle, draftRepository);
  }

  void stubPublish() {
    when(
      () => publishArticle(
        title: _title,
        text: _text,
        tags: _tags,
        difficulty: _difficulty,
      ),
    ).thenAnswer((_) async => makeArticle(1));
  }

  void stubUpdate(int articleId) {
    when(
      () => updateArticle(
        articleId: articleId,
        title: _title,
        text: _text,
        tags: _tags,
        difficulty: _difficulty,
      ),
    ).thenAnswer((_) async {});
  }

  void stubDraftDelete(String id) {
    when(() => draftRepository.delete(id)).thenAnswer((_) async {});
  }

  group('создание статьи', () {
    blocTest<ArticlePublishBloc, ArticlePublishState>(
      'успех: Publishing, затем Published, черновик удаляется',
      setUp: () {
        stubPublish();
        stubDraftDelete('draft-1');
      },
      build: buildBloc,
      act: (bloc) => bloc.add(request(draftId: 'draft-1')),
      expect: () => [
        isA<ArticlePublishing>(),
        isA<ArticlePublished>(),
      ],
      verify: (_) {
        verify(
          () => publishArticle(
            title: _title,
            text: _text,
            tags: _tags,
            difficulty: _difficulty,
          ),
        ).called(1);
        verify(() => draftRepository.delete('draft-1')).called(1);
        verifyNoMoreInteractions(updateArticle);
      },
    );

    blocTest<ArticlePublishBloc, ArticlePublishState>(
      'без id черновика ничего не удаляется',
      setUp: stubPublish,
      build: buildBloc,
      act: (bloc) => bloc.add(request()),
      expect: () => [
        isA<ArticlePublishing>(),
        isA<ArticlePublished>(),
      ],
      verify: (_) {
        verifyNoMoreInteractions(draftRepository);
      },
    );

    blocTest<ArticlePublishBloc, ArticlePublishState>(
      'ошибка отправки: Failure, черновик остаётся',
      setUp: () {
        when(
          () => publishArticle(
            title: _title,
            text: _text,
            tags: _tags,
            difficulty: _difficulty,
          ),
        ).thenThrow(Exception('offline'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(request(draftId: 'draft-1')),
      expect: () => [
        isA<ArticlePublishing>(),
        isA<ArticlePublishFailure>().having(
          (state) => state.message,
          'message',
          isNotEmpty,
        ),
      ],
      verify: (_) {
        verifyNoMoreInteractions(draftRepository);
      },
    );

    blocTest<ArticlePublishBloc, ArticlePublishState>(
      'ошибка удаления черновика не превращает успех в неудачу',
      setUp: () {
        stubPublish();
        when(() => draftRepository.delete('draft-1'))
            .thenThrow(Exception('disk error'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(request(draftId: 'draft-1')),
      expect: () => [
        isA<ArticlePublishing>(),
        isA<ArticlePublished>(),
      ],
    );
  });

  group('правка опубликованной статьи', () {
    blocTest<ArticlePublishBloc, ArticlePublishState>(
      'с articleId вызывается обновление, а не создание',
      setUp: () {
        stubUpdate(5);
        stubDraftDelete('edit_5');
      },
      build: buildBloc,
      act: (bloc) => bloc.add(request(draftId: 'edit_5', articleId: 5)),
      expect: () => [
        isA<ArticlePublishing>(),
        isA<ArticlePublished>(),
      ],
      verify: (_) {
        verify(
          () => updateArticle(
            articleId: 5,
            title: _title,
            text: _text,
            tags: _tags,
            difficulty: _difficulty,
          ),
        ).called(1);
        verify(() => draftRepository.delete('edit_5')).called(1);
        verifyNoMoreInteractions(publishArticle);
      },
    );

    blocTest<ArticlePublishBloc, ArticlePublishState>(
      'ошибка обновления: Failure, черновик правки остаётся',
      setUp: () {
        when(
          () => updateArticle(
            articleId: 5,
            title: _title,
            text: _text,
            tags: _tags,
            difficulty: _difficulty,
          ),
        ).thenThrow(Exception('403'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(request(draftId: 'edit_5', articleId: 5)),
      expect: () => [
        isA<ArticlePublishing>(),
        isA<ArticlePublishFailure>(),
      ],
      verify: (_) {
        verifyNoMoreInteractions(draftRepository);
      },
    );
  });

  group('защита от двойного нажатия', () {
    late Completer<ArticleModel> pending;

    blocTest<ArticlePublishBloc, ArticlePublishState>(
      'пока идёт отправка, повторный запрос игнорируется',
      setUp: () {
        pending = Completer<ArticleModel>();

        when(
          () => publishArticle(
            title: _title,
            text: _text,
            tags: _tags,
            difficulty: _difficulty,
          ),
        ).thenAnswer((_) => pending.future);

        addTearDown(() {
          if (!pending.isCompleted) pending.complete(makeArticle(1));
        });
      },
      build: buildBloc,
      act: (bloc) async {
        bloc
          ..add(request())
          ..add(request());

        await pumpEventQueue();
        pending.complete(makeArticle(1));
      },
      expect: () => [
        isA<ArticlePublishing>(),
        isA<ArticlePublished>(),
      ],
      verify: (_) {
        verify(
          () => publishArticle(
            title: _title,
            text: _text,
            tags: _tags,
            difficulty: _difficulty,
          ),
        ).called(1);
      },
    );
  });
}
