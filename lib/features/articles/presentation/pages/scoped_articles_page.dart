import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/features/articles/domain/entities/article_scope.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_event.dart';
import 'package:re_articles/features/articles/presentation/widgets/articles_feed_list.dart';

class ScopedArticlesPage extends StatelessWidget {
  final String title;
  final ArticleScope scope;
  final String emptyText;

  const new({
    super.key,
    required this.title,
    required this.scope,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.createArticleFeedBloc(scope: scope)
        ..add(const LoadArticles()),
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ArticlesFeedList(
          emptyText: emptyText,
          editable: scope == ArticleScope.mine,
        ),
      ),
    );
  }
}