import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/core/config.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/core/utils/confirm_dialog.dart';
import 'package:re_articles/core/utils/haptics.dart';
import 'package:re_articles/features/account/presentation/pages/author_args.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_state.dart';
import 'package:re_articles/features/articles/presentation/pages/article_details_args.dart';
import 'package:re_articles/features/articles/presentation/utils/edit_article.dart';
import 'package:re_articles/features/articles/presentation/widgets/article_widget.dart';

class ArticlesFeedList extends StatefulWidget {
  final String? emptyText;

  final bool hasFloatingButton;

  final Widget? header;
  final bool editable;

  const new({
    super.key,
    this.emptyText,
    this.hasFloatingButton = false,
    this.header,
    this.editable = false,
  });

  @override
  State<ArticlesFeedList> createState() => _ArticlesFeedListState();
}

class _ArticlesFeedListState extends State<ArticlesFeedList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.extentAfter < Config.loadMoreThreshold) {
      context.read<ArticleFeedBloc>().add(const LoadMoreArticles());
    }
  }

  Future<void> _confirmDelete(BuildContext context, int articleId) async {
    final confirmed = await confirmDestructive(
      context,
      title: context.l10n.deleteArticleTitle,
      message: context.l10n.deleteArticleMessage,
    );

    if (confirmed && context.mounted) {
      Haptics.medium();
      context.read<ArticleFeedBloc>().add(
        DeleteArticleEvent(articleId: articleId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final layouts = context.layouts;
    final header = widget.header;
    final headerCount = header == null ? 0 : 1;

    final bottomPadding = widget.hasFloatingButton
        ? layouts.writeArticleButtonSize + spacing.m * 2 + spacing.xl
        : spacing.m;

    return BlocBuilder<ArticleFeedBloc, ArticleFeedState>(
      builder: (context, state) {
        if (state is ArticleFeedInitial || state is ArticleFeedLoading) {
          if (header != null) {
            return ListView(
              children: [
                header,
                Padding(
                  padding: EdgeInsets.all(spacing.l),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        }

        if (state is ArticleFeedError) {
          return Center(
            child: Text(state.message, textAlign: TextAlign.center),
          );
        }

        if (state is ArticleFeedLoaded) {
          final isEmpty = state.articles.isEmpty;

          if (isEmpty && header == null) {
            return Center(
              child: Text(widget.emptyText ?? context.l10n.noArticlesYet, textAlign: TextAlign.center),
            );
          }

          final bodyCount = isEmpty
              ? 1
              : state.articles.length + (state.isLoadingMore ? 1 : 0);

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: bottomPadding),
            itemCount: headerCount + bodyCount,
            itemBuilder: (context, index) {
              if (header != null && index == 0) return header;

              final i = index - headerCount;

              if (isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(spacing.l),
                  child: Center(
                    child: Text(widget.emptyText ?? context.l10n.noArticlesYet, textAlign: TextAlign.center),
                  ),
                );
              }

              if (i >= state.articles.length) {
                return Padding(
                  padding: EdgeInsets.all(spacing.l),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              final article = state.articles[i];
              final authorId = article.authorId;

              return RepaintBoundary(
                key: ValueKey(article.id),
                child: ArticleWidget(
                  articleId: article.id,
                  title: article.title,
                  preview: article.preview,
                  authorName: article.authorName,
                  likes: article.likes,
                  views: article.views,
                  tags: article.tags,
                  difficality: article.difficulty,
                  isLiked: article.likedByMe,
                  onEdit: widget.editable ? () => editArticle(context, article) : null,
                  onDelete: widget.editable
                      ? () => _confirmDelete(context, article.id)
                      : null,
                  onTap: () => Navigator.pushNamed(
                    context,
                    RouteNames.articleDetails,
                    arguments: ArticleDetailsArgs(
                      article: article,
                      bloc: context.read<ArticleFeedBloc>(),
                    ),
                  ),
                  onAuthorTap: authorId == null
                      ? null
                      : () => Navigator.pushNamed(
                            context,
                            RouteNames.author,
                            arguments: AuthorArgs(
                              id: authorId,
                              name: article.authorName,
                            ),
                          ),
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}