import 'package:re_articles/features/articles/data/models/article_model.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_bloc.dart';

class ArticleDetailsArgs {
  final ArticleModel article;
  final ArticleFeedBloc bloc;

  const ArticleDetailsArgs({
    required this.article,
    required this.bloc,
  });
}