import 'package:re_articles/l10n/l10n.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/config.dart';

import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/features/account/presentation/pages/author_args.dart';
import 'package:re_articles/features/articles/data/models/article_model.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_state.dart';
import 'package:re_articles/features/articles/presentation/widgets/fast_actions_widget.dart';

class ArticlesDetails extends StatefulWidget {
  final ArticleModel article;

  const ArticlesDetails({
    super.key,
    required this.article,
  });

  @override
  State<ArticlesDetails> createState() => _ArticlesDetailsState();
}

class _ArticlesDetailsState extends State<ArticlesDetails> {
  late final QuillController _controller;
  final _barVisible = ValueNotifier<bool>(true);
  Timer? _barTimer;
  double _progress = 0;

  @override
  void initState() {
    super.initState();

    final document = Document.fromJson(
      jsonDecode(widget.article.text),
    );

    _controller = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );

    Injection.articleApi.trackOpen(widget.article.id).ignore();
  }

  @override
  void dispose() {
    if (_progress >= Config.minReadProgress) {
      Injection.articleApi
          .trackRead(widget.article.id, _progress)
          .ignore();
    }

    _barTimer?.cancel();
    _barVisible.dispose();
    _controller.dispose();
    super.dispose();
  }

  ArticleModel _currentArticle(ArticleFeedState state) {
    if (state is ArticleFeedLoaded) {
      for (final article in state.articles) {
        if (article.id == widget.article.id) return article;
      }
    }

    return widget.article;
  }

  bool _onNotification(Notification notification) {
    final ScrollMetrics? metrics = switch (notification) {
      ScrollNotification(:final metrics) => metrics,
      ScrollMetricsNotification(:final metrics) => metrics,
      _ => null,
    };

    if (metrics == null || metrics.axis != Axis.vertical) return false;

    if (notification is ScrollUpdateNotification) {
      if ((notification.scrollDelta ?? 0).abs() > Config.scrollThreshold) {
        _barTimer?.cancel();
        _barVisible.value = false;
      }
    } else if (notification is ScrollEndNotification) {
      _barTimer?.cancel();
      _barTimer = Timer(Config.barReturnDelay, () => _barVisible.value = true);
    }

    final max = metrics.maxScrollExtent;
    final progress = max <= 0 ? 1.0 : (metrics.pixels / max).clamp(0.0, 1.0);

    if (progress > _progress) _progress = progress;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final layouts = context.layouts;
    
    final barReserve = layouts.authorIconSize +
        kMinInteractiveDimension +
        spacing.m * 3 +
        spacing.s;

    return Scaffold(
      appBar: AppBar(title: Text(widget.article.title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: layouts.articleContentMaxWidth,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.m),
                  child: NotificationListener<Notification>(
                    onNotification: _onNotification,
                    child: QuillEditor.basic(
                      controller: _controller,
                      config: QuillEditorConfig(
                        padding: EdgeInsets.only(
                          top: spacing.m,
                          bottom: barReserve,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _barVisible,
                    builder: (context, visible, child) => IgnorePointer(
                      ignoring: !visible,
                      child: AnimatedSlide(
                        offset: visible ? Offset.zero : const Offset(0, 1),
                        duration: Config.barAnimation,
                        curve: Curves.easeOut,
                        child: AnimatedOpacity(
                          opacity: visible ? 1 : 0,
                          duration: Config.barAnimation,
                          child: child,
                        ),
                      ),
                    ),
                    child: BlocSelector<ArticleFeedBloc, ArticleFeedState,
                        ArticleModel>(
                      selector: _currentArticle,
                      builder: (context, article) =>
                          _ArticleBottomBar(article: article),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ArticleBottomBar extends StatelessWidget {
  final ArticleModel article;

  const _ArticleBottomBar({required this.article});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final layouts = context.layouts;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final authorId = article.authorId;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.m,
        0,
        spacing.m,
        spacing.s,
      ),
      child: SizedBox(
        width: double.infinity,
        child: GlassContainer(
          settings: LiquidGlassSettings(
            glassColor: colors.surfaceContainer,
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing.m),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: authorId == null
                    ? null
                    : () => Navigator.pushNamed(
                          context,
                          RouteNames.author,
                          arguments: AuthorArgs(
                            id: authorId,
                            name: article.authorName,
                          ),
                        ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: layouts.authorIconSize / 2,
                        backgroundColor: colors.primaryContainer,
                        child: Icon(
                          Icons.person,
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                      SizedBox(width: spacing.m),
                      Expanded(
                        child: Text(
                          article.authorName ?? context.l10n.unknownAuthor,
                          style: theme.textTheme.headlineMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                FastActions(
                  articleId: article.id,
                  likes: article.likes,
                  views: article.views,
                  isLiked: article.likedByMe,
                  onHidden: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}