import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:re_articles/features/articles/data/models/article_model.dart';
import 'package:re_articles/features/articles/data/models/articles_response_model.dart';
import 'package:re_articles/features/articles/domain/entities/article_scope.dart';
import 'package:re_articles/features/articles/domain/usecases/delete_article.dart';
import 'package:re_articles/features/articles/domain/usecases/get_articles.dart';
import 'package:re_articles/features/articles/domain/usecases/like_article.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_state.dart';

import '../../helpers/fixtures.dart';

class MockGetArticles extends Mock implements GetArticles {}

class MockLikeArticle extends Mock implements LikeArticle {}

class MockDeleteArticle extends Mock implements DeleteArticle {}

// Размер страницы, зашитый в блоке (_pageSize).
const pageSize = 10;

// Матчер для состояния «лента загружена» с заданным порядком id.
Matcher loadedIds(List<int> ids) {
  return isA<ArticleFeedLoaded>().having(
    (state) => state.articles.map((article) => article.id).toList(),
    'ids',
    ids,
  );
}

// Матчер для статьи с заданными лайками (единственной в ленте).
Matcher singleArticle({required int likes, required bool liked}) {
  return isA<ArticleFeedLoaded>()
      .having((state) => state.articles.single.likes, 'likes', likes)
      .having((state) => state.articles.single.likedByMe, 'likedByMe', liked);
}

void main() {
  late MockGetArticles getArticles;
  late MockLikeArticle likeArticle;
  late MockDeleteArticle deleteArticle;

  setUp(() {
    getArticles = MockGetArticles();
    likeArticle = MockLikeArticle();
    deleteArticle = MockDeleteArticle();
  });

  ArticleFeedBloc buildBloc({
    ArticleScope scope = ArticleScope.all,
    int? authorId,
  }) {
    return ArticleFeedBloc(
      getArticles,
      likeArticle,
      deleteArticle,
      scope: scope,
      authorId: authorId,
    );
  }

  void stubPage({
    required int offset,
    required List<ArticleModel> articles,
    required int total,
    ArticleScope scope = ArticleScope.all,
    int? authorId,
  }) {
    when(
      () => getArticles(
        offset: offset,
        limit: pageSize,
        scope: scope,
        authorId: authorId,
      ),
    ).thenAnswer(
      (_) async => ArticlesResponseModel(
        articles: articles,
        offset: offset,
        limit: pageSize,
        total: total,
      ),
    );
  }

  // Ждём, пока обработчики событий (с мгновенными заглушками) завершатся.
  Future<void> settle() => pumpEventQueue();

  group('LoadArticles', () {
    final a1 = makeArticle(1);
    final a2 = makeArticle(2);

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'успех: Loading, затем Loaded, hasMore считается по total',
      setUp: () => stubPage(offset: 0, articles: [a1, a2], total: 12),
      build: buildBloc,
      act: (bloc) => bloc.add(const LoadArticles()),
      expect: () => [
        const ArticleFeedLoading(),
        ArticleFeedLoaded(articles: [a1, a2], hasMore: true),
      ],
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'hasMore = false, когда загружено всё',
      setUp: () => stubPage(offset: 0, articles: [a1, a2], total: 2),
      build: buildBloc,
      act: (bloc) => bloc.add(const LoadArticles()),
      expect: () => [
        const ArticleFeedLoading(),
        ArticleFeedLoaded(articles: [a1, a2], hasMore: false),
      ],
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'ошибка: Loading, затем Error',
      setUp: () {
        when(
          () => getArticles(
            offset: 0,
            limit: pageSize,
            scope: ArticleScope.all,
            authorId: null,
          ),
        ).thenThrow(Exception('boom'));
      },
      build: buildBloc,
      act: (bloc) => bloc.add(const LoadArticles()),
      expect: () => [
        const ArticleFeedLoading(),
        isA<ArticleFeedError>(),
      ],
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'передаёт scope и authorId в запрос',
      setUp: () => stubPage(
        offset: 0,
        articles: [a1],
        total: 1,
        scope: ArticleScope.mine,
        authorId: 7,
      ),
      build: () => buildBloc(scope: ArticleScope.mine, authorId: 7),
      act: (bloc) => bloc.add(const LoadArticles()),
      verify: (_) {
        verify(
          () => getArticles(
            offset: 0,
            limit: pageSize,
            scope: ArticleScope.mine,
            authorId: 7,
          ),
        ).called(1);
      },
    );
  });

  group('LoadMoreArticles', () {
    final page1 = [makeArticle(1), makeArticle(2)];
    final page2 = [makeArticle(3)];

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'дозагружает следующую страницу и дописывает её в конец',
      setUp: () {
        stubPage(offset: 0, articles: page1, total: 3);
        stubPage(offset: 2, articles: page2, total: 3);
      },
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const LoadArticles());
        await settle();
        bloc.add(const LoadMoreArticles());
      },
      expect: () => [
        const ArticleFeedLoading(),
        loadedIds([1, 2]),
        isA<ArticleFeedLoaded>().having(
          (state) => state.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        isA<ArticleFeedLoaded>()
            .having(
              (state) => state.articles.map((a) => a.id).toList(),
              'ids',
              [1, 2, 3],
            )
            .having((state) => state.hasMore, 'hasMore', false)
            .having((state) => state.isLoadingMore, 'isLoadingMore', false),
      ],
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'ничего не делает, если больше нечего загружать',
      seed: () => ArticleFeedLoaded(articles: page1, hasMore: false),
      build: buildBloc,
      act: (bloc) => bloc.add(const LoadMoreArticles()),
      expect: () => <ArticleFeedState>[],
      verify: (_) {
        verifyNoMoreInteractions(getArticles);
      },
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'ошибка подгрузки возвращает ленту без индикатора и не теряет статьи',
      setUp: () {
        stubPage(offset: 0, articles: page1, total: 5);
        when(
          () => getArticles(
            offset: 2,
            limit: pageSize,
            scope: ArticleScope.all,
            authorId: null,
          ),
        ).thenThrow(Exception('offline'));
      },
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const LoadArticles());
        await settle();
        bloc.add(const LoadMoreArticles());
      },
      skip: 3,
      expect: () => [
        isA<ArticleFeedLoaded>()
            .having((state) => state.articles.length, 'length', 2)
            .having((state) => state.isLoadingMore, 'isLoadingMore', false),
      ],
    );
  });

  group('LikeArticleEvent', () {
    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'лайк: счётчик растёт сразу, на сервер уходит liked = true',
      setUp: () {
        when(() => likeArticle(articleId: 1, liked: true))
            .thenAnswer((_) async {});
      },
      build: buildBloc,
      seed: () => ArticleFeedLoaded(
        articles: [makeArticle(1, likes: 0)],
        hasMore: false,
      ),
      act: (bloc) => bloc.add(const LikeArticleEvent(articleId: 1)),
      expect: () => [singleArticle(likes: 1, liked: true)],
      verify: (_) {
        verify(() => likeArticle(articleId: 1, liked: true)).called(1);
      },
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'повторное нажатие на лайкнутую статью снимает лайк',
      setUp: () {
        when(() => likeArticle(articleId: 1, liked: false))
            .thenAnswer((_) async {});
      },
      build: buildBloc,
      seed: () => ArticleFeedLoaded(
        articles: [makeArticle(1, likes: 3, likedByMe: true)],
        hasMore: false,
      ),
      act: (bloc) => bloc.add(const LikeArticleEvent(articleId: 1)),
      expect: () => [singleArticle(likes: 2, liked: false)],
      verify: (_) {
        verify(() => likeArticle(articleId: 1, liked: false)).called(1);
      },
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'ошибка сети откатывает только эту статью',
      setUp: () {
        when(() => likeArticle(articleId: 1, liked: true))
            .thenThrow(Exception('offline'));
      },
      build: buildBloc,
      seed: () => ArticleFeedLoaded(
        articles: [makeArticle(1, likes: 0)],
        hasMore: false,
      ),
      act: (bloc) => bloc.add(const LikeArticleEvent(articleId: 1)),
      expect: () => [
        singleArticle(likes: 1, liked: true),
        singleArticle(likes: 0, liked: false),
      ],
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'быстрые повторные нажатия не отправляют второй запрос',
      setUp: () {
        // Запрос «висит», пока мы его не завершим.
        final pending = Completer<void>();

        when(() => likeArticle(articleId: 1, liked: true))
            .thenAnswer((_) => pending.future);

        addTearDown(() {
          if (!pending.isCompleted) pending.complete();
        });

        _pendingLike = pending;
      },
      build: buildBloc,
      seed: () => ArticleFeedLoaded(
        articles: [makeArticle(1)],
        hasMore: false,
      ),
      act: (bloc) async {
        bloc
          ..add(const LikeArticleEvent(articleId: 1))
          ..add(const LikeArticleEvent(articleId: 1));

        await settle();
        _pendingLike.complete();
      },
      expect: () => [singleArticle(likes: 1, liked: true)],
      verify: (_) {
        verify(() => likeArticle(articleId: 1, liked: true)).called(1);
      },
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'неизвестная статья: ни состояния, ни запроса',
      build: buildBloc,
      seed: () => ArticleFeedLoaded(
        articles: [makeArticle(1)],
        hasMore: false,
      ),
      act: (bloc) => bloc.add(const LikeArticleEvent(articleId: 999)),
      expect: () => <ArticleFeedState>[],
      verify: (_) {
        verifyNoMoreInteractions(likeArticle);
      },
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'пока лента не загружена, лайк игнорируется',
      build: buildBloc,
      act: (bloc) => bloc.add(const LikeArticleEvent(articleId: 1)),
      expect: () => <ArticleFeedState>[],
    );
  });

  group('DeleteArticleEvent', () {
    final articles = [makeArticle(1), makeArticle(2), makeArticle(3)];

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'убирает статью из ленты и удаляет её на сервере',
      setUp: () {
        when(() => deleteArticle(articleId: 2)).thenAnswer((_) async {});
      },
      build: buildBloc,
      seed: () => ArticleFeedLoaded(articles: articles, hasMore: false),
      act: (bloc) => bloc.add(const DeleteArticleEvent(articleId: 2)),
      expect: () => [loadedIds([1, 3])],
      verify: (_) {
        verify(() => deleteArticle(articleId: 2)).called(1);
      },
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'при ошибке возвращает статью на прежнее место',
      setUp: () {
        when(() => deleteArticle(articleId: 2)).thenThrow(Exception('offline'));
      },
      build: buildBloc,
      seed: () => ArticleFeedLoaded(articles: articles, hasMore: false),
      act: (bloc) => bloc.add(const DeleteArticleEvent(articleId: 2)),
      expect: () => [
        loadedIds([1, 3]),
        loadedIds([1, 2, 3]),
      ],
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'неизвестная статья ничего не меняет',
      build: buildBloc,
      seed: () => ArticleFeedLoaded(articles: articles, hasMore: false),
      act: (bloc) => bloc.add(const DeleteArticleEvent(articleId: 999)),
      expect: () => <ArticleFeedState>[],
      verify: (_) {
        verifyNoMoreInteractions(deleteArticle);
      },
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'после удаления подгрузка берёт смещение на единицу меньше',
      setUp: () {
        stubPage(
          offset: 0,
          articles: [makeArticle(1), makeArticle(2), makeArticle(3)],
          total: 5,
        );
        stubPage(offset: 2, articles: [makeArticle(4)], total: 5);
        when(() => deleteArticle(articleId: 1)).thenAnswer((_) async {});
      },
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const LoadArticles());
        await settle();
        bloc.add(const DeleteArticleEvent(articleId: 1));
        await settle();
        bloc.add(const LoadMoreArticles());
      },
      verify: (_) {
        verify(
          () => getArticles(
            offset: 2,
            limit: pageSize,
            scope: ArticleScope.all,
            authorId: null,
          ),
        ).called(1);
      },
    );
  });

  group('HideArticleEvent и RestoreHiddenArticleEvent', () {
    final articles = [makeArticle(1), makeArticle(2), makeArticle(3)];

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'скрывает статью локально, без запросов к серверу',
      build: buildBloc,
      seed: () => ArticleFeedLoaded(articles: articles, hasMore: false),
      act: (bloc) => bloc.add(const HideArticleEvent(articleId: 2)),
      expect: () => [loadedIds([1, 3])],
      verify: (_) {
        verifyNoMoreInteractions(deleteArticle);
      },
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'Restore возвращает скрытую статью на прежнее место',
      build: buildBloc,
      seed: () => ArticleFeedLoaded(articles: articles, hasMore: false),
      act: (bloc) async {
        bloc.add(const HideArticleEvent(articleId: 2));
        await settle();
        bloc.add(const RestoreHiddenArticleEvent());
      },
      expect: () => [
        loadedIds([1, 3]),
        loadedIds([1, 2, 3]),
      ],
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'Restore без скрытой статьи ничего не делает',
      build: buildBloc,
      seed: () => ArticleFeedLoaded(articles: articles, hasMore: false),
      act: (bloc) => bloc.add(const RestoreHiddenArticleEvent()),
      expect: () => <ArticleFeedState>[],
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'повторный Restore не дублирует статью',
      build: buildBloc,
      seed: () => ArticleFeedLoaded(articles: articles, hasMore: false),
      act: (bloc) async {
        bloc.add(const HideArticleEvent(articleId: 2));
        await settle();
        bloc.add(const RestoreHiddenArticleEvent());
        await settle();
        bloc.add(const RestoreHiddenArticleEvent());
      },
      expect: () => [
        loadedIds([1, 3]),
        loadedIds([1, 2, 3]),
      ],
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'скрытие неизвестной статьи ничего не меняет',
      build: buildBloc,
      seed: () => ArticleFeedLoaded(articles: articles, hasMore: false),
      act: (bloc) => bloc.add(const HideArticleEvent(articleId: 999)),
      expect: () => <ArticleFeedState>[],
    );

    blocTest<ArticleFeedBloc, ArticleFeedState>(
      'после скрытия подгрузка берёт смещение на единицу меньше',
      setUp: () {
        stubPage(
          offset: 0,
          articles: [makeArticle(1), makeArticle(2), makeArticle(3)],
          total: 5,
        );
        stubPage(offset: 2, articles: [makeArticle(4)], total: 5);
      },
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const LoadArticles());
        await settle();
        bloc.add(const HideArticleEvent(articleId: 1));
        await settle();
        bloc.add(const LoadMoreArticles());
      },
      verify: (_) {
        verify(
          () => getArticles(
            offset: 2,
            limit: pageSize,
            scope: ArticleScope.all,
            authorId: null,
          ),
        ).called(1);
      },
    );
  });
}

// Завершаемый вручную запрос лайка для теста «быстрых нажатий».
late Completer<void> _pendingLike;
