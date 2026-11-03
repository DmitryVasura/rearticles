import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/features/articles/data/models/tag_model.dart';
import 'package:re_articles/features/articles/presentation/widgets/article_tag_widget.dart';
import 'package:re_articles/features/articles/presentation/widgets/difficulty_widget.dart';
import 'package:re_articles/features/articles/presentation/widgets/fast_actions_widget.dart';
import 'package:re_articles/features/articles/presentation/widgets/manageable_card.dart';

const _previewMaxLines = 8;

class ArticleWidget extends StatelessWidget {
  final String title;
  final String preview;
  final String? authorName;
  final List<TagModel> tags;
  final VoidCallback? onTap;
  final VoidCallback? onAuthorTap;

  /// Если оба заданы, карточка получает свайп и меню «Edit / Delete».
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  final int articleId;
  final int likes;
  final int views;
  final String difficality;
  final bool isLiked;

  const ArticleWidget({
    super.key,
    required this.articleId,
    required this.title,
    required this.preview,
    required this.likes,
    required this.views,
    required this.tags,
    required this.difficality,
    required this.isLiked,
    this.authorName,
    this.onTap,
    this.onAuthorTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final spacing = context.spacing;

    // Без пропорции карточке нужна явная ширина на весь экран.
    final card = SizedBox(
      width: double.infinity,
      child: GlassContainer(
        settings: LiquidGlassSettings(
          glassColor: colors.surfaceContainer,
        ),
        child: Padding(
          padding: EdgeInsets.all(spacing.m),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AuthorLine(
                authorName: authorName,
                tags: tags,
                onAuthorTap: onAuthorTap,
              ),
              SizedBox(height: spacing.m),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: textStyle.headlineMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  DifficalityWidget(
                    difficality: ArticleDifficality.fromName(difficality),
                  ),
                ],
              ),
              SizedBox(height: spacing.m),
              Text(
                preview,
                maxLines: _previewMaxLines,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing.m),
              FastActions(
                articleId: articleId,
                likes: likes,
                views: views,
                isLiked: isLiked,
              ),
            ],
          ),
        ),
      ),
    );

    final edit = onEdit;
    final delete = onDelete;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.m,
        vertical: spacing.s,
      ),
      child: edit != null && delete != null
          ? ManageableCard(
              onTap: onTap,
              onEdit: edit,
              onDelete: delete,
              child: card,
            )
          : GestureDetector(onTap: onTap, child: card),
    );
  }
}
class _AuthorLine extends StatelessWidget {
  final String? authorName;
  final List<TagModel> tags;
  final VoidCallback? onAuthorTap;

  const _AuthorLine({
    required this.authorName,
    required this.tags,
    this.onAuthorTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final spacing = context.spacing;

    return Row(
      children: [
        GestureDetector(
          onTap: onAuthorTap,
          behavior: HitTestBehavior.opaque,
          child: const _UserIcon(),
        ),
        SizedBox(width: spacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onAuthorTap,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  authorName ?? context.l10n.unknownAuthor,
                  style: textStyle.headlineMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: spacing.xs),
              _TagsLine(tags: tags),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserIcon extends StatelessWidget {
  const _UserIcon();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = context.layouts.authorIconSize;

    return ClipRRect(
      child: GlassContainer(
        height: size,
        width: size,
        shape: LiquidOval(),
        child: Container(
          height: size,
          width: size,
          color: colors.surfaceContainerHigh,
          child: Icon(
            Icons.person,
            color: colors.surfaceContainer,
            size: size,
          ),
        ),
      ),
    );
  }
}

class _TagsLine extends StatelessWidget {
  final List<TagModel> tags;

  const _TagsLine({required this.tags});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.layouts.tagHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];

          return Padding(
            padding: EdgeInsets.all(context.spacing.xs),
            child: ArticleTagWidget(tag: tag.tag),
          );
        },
      ),
    );
  }
}