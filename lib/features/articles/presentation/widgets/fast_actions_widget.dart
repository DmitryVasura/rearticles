import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/core/utils/haptics.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_event.dart';
import 'package:re_articles/features/articles/presentation/utils/article_moderation.dart';

class FastActions extends StatelessWidget {
  final int articleId;
  final int likes;
  final int views;
  final bool isLiked;

  /// Вызывается после того, как статья скрыта («Report» или «Don't like»).
  final VoidCallback? onHidden;

  const FastActions({
    super.key,
    required this.articleId,
    required this.likes,
    required this.views,
    required this.isLiked,
    this.onHidden,
  });

  void _onLikePressed(BuildContext context) {
    Haptics.light();

    context.read<ArticleFeedBloc>().add(
      LikeArticleEvent(articleId: articleId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        const Divider(),
        Row(
          children: [
            // На узком экране счётчики сжимаются, а не вылезают за край.
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => _onLikePressed(context),
                      icon: Icon(
                        isLiked
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: isLiked ? colors.primary : null,
                      ),
                    ),
                    Text('$likes'),
                    SizedBox(width: spacing.m),
                    const Icon(CupertinoIcons.eye),
                    SizedBox(width: spacing.s),
                    Text('$views'),
                  ],
                ),
              ),
            ),
            SizedBox(width: spacing.s),
            GlassPullDownButton(
              items: [
                GlassMenuItem(
                  title: context.l10n.report,
                  icon: const Icon(CupertinoIcons.flag),
                  onTap: () => reportArticle(
                    context,
                    articleId,
                    onHidden: onHidden,
                  ),
                ),
                GlassMenuItem(
                  title: context.l10n.dontLike,
                  icon: const Icon(Icons.thumb_down_outlined),
                  onTap: () => dislikeArticle(
                    context,
                    articleId,
                    onHidden: onHidden,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}