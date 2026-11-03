import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/features/articles/domain/entities/article_scope.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_event.dart';
import 'package:re_articles/features/articles/presentation/widgets/articles_feed_list.dart';

class ArticlesListPageState extends StatefulWidget {
  const ArticlesListPageState({super.key});

  @override
  State<ArticlesListPageState> createState() => _ArticlesListPageStateState();
}

class _ArticlesListPageStateState extends State<ArticlesListPageState> {
  var _scope = ArticleScope.recommended;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey(_scope),
      create: (_) => Injection.createArticleFeedBloc(scope: _scope)
        ..add(const LoadArticles()),
      child: _ArticlesFeedView(
        scope: _scope,
        onScopeChanged: (scope) => setState(() => _scope = scope),
      ),
    );
  }
}

class _ArticlesFeedView extends StatelessWidget {
  final ArticleScope scope;
  final ValueChanged<ArticleScope> onScopeChanged;

  const _ArticlesFeedView({
    required this.scope,
    required this.onScopeChanged,
  });

  Future<void> _onAddTap(BuildContext context) async {
    await Navigator.pushNamed(context, RouteNames.chooseWhatToWrite);

    if (context.mounted) {
      context.read<ArticleFeedBloc>().add(const LoadArticles());
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.m,
                  vertical: spacing.s,
                ),
                child: Row(
                  children: [
                    GlassChip(
                      label: context.l10n.forYou,
                      selected: scope == ArticleScope.recommended,
                      onTap: () => onScopeChanged(ArticleScope.recommended),
                    ),
                    SizedBox(width: spacing.s),
                    GlassChip(
                      label: context.l10n.latest,
                      selected: scope == ArticleScope.all,
                      onTap: () => onScopeChanged(ArticleScope.all),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: ArticlesFeedList(hasFloatingButton: true),
              ),
            ],
          ),
          _WriteButton(onAddTap: () => _onAddTap(context)),
        ],
      ),
    );
  }
}

class _WriteButton extends StatelessWidget {
  final VoidCallback onAddTap;

  const _WriteButton({
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final layouts = context.layouts;
    final colors = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: GlassIconButton(
          size: layouts.writeArticleButtonSize,
          icon: Icon(
            Icons.add,
            color: colors.onPrimaryContainer,
          ),
          onPressed: onAddTap,
          settings: LiquidGlassSettings(
            glassColor: colors.primary.withAlpha(170),
          ),
        ),
      ),
    );
  }
}