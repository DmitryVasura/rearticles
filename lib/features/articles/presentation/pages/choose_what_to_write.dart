import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/radiuses.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/features/articles/domain/entities/article_draft.dart';
import 'package:re_articles/features/articles/presentation/bloc/drafts/article_draft_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/drafts/article_draft_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/drafts/article_draft_state.dart';
import 'package:re_articles/features/articles/presentation/widgets/draft_widget.dart';

class ChooseWhatToWrite extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.createArticleDraftBloc()
        ..add(const LoadDrafts()),
      child: const _ChooseWhatToWriteView(),
    );
  }
}

class _ChooseWhatToWriteView extends StatelessWidget {
  const _ChooseWhatToWriteView();

  Future<void> _openDraft(
    BuildContext context,
    String draftId,
  ) async {
    await Navigator.pushNamed(
      context,
      RouteNames.createArticle,
      arguments: draftId,
    );

    if (context.mounted) {
      context.read<ArticleDraftBloc>().add(
        const LoadDrafts(),
      );
    }
  }

  void _publishDraft(BuildContext context, ArticleDraft draft) {
    Navigator.pushNamed(
      context,
      RouteNames.finishWriting,
      arguments: draft.toArticle(),
    );
  }

  void _deleteDraft(BuildContext context, String id) {
    context.read<ArticleDraftBloc>().add(DeleteDraft(id));
  }

  Future<void> _createArticle(BuildContext context) async {
    await Navigator.pushNamed(
      context,
      RouteNames.createArticle,
    );

    if (context.mounted) {
      context.read<ArticleDraftBloc>().add(
        const LoadDrafts(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final layouts = context.layouts;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.chooseDraftOrNew,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<ArticleDraftBloc, ArticleDraftState>(
            builder: (context, state) {
              if (state is ArticleDraftLoading ||
                  state is ArticleDraftInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ArticleDraftError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(spacing.m),
                    child: Text(
                      context.l10n.failedLoadDrafts(state.message),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (state is ArticleDraftsLoaded) {
                if (state.drafts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(spacing.m),
                      child: Text(
                        context.l10n.noDraftsYet,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(
                    top: spacing.xs,
                    bottom: layouts.writeArticleButtonSize +
                        spacing.m * 2 +
                        spacing.xl,
                  ),
                  itemCount: state.drafts.length,
                  itemBuilder: (context, index) {
                    final draft = state.drafts[index];

                    return DraftWidget(
                      key: ValueKey(draft.id),
                      draft: draft,
                      onTap: () => _openDraft(context, draft.id),
                      onPublish: () => _publishDraft(context, draft),
                      onDelete: () => _deleteDraft(context, draft.id),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _WriteArticleButton(
              onTap: () => _createArticle(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _WriteArticleButton extends StatelessWidget {
  const new({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final layouts = context.layouts;
    final colors = Theme.of(context).colorScheme;
    final radiuses = context.radiuses;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.m,
        spacing.s,
        spacing.m,
        spacing.m,
      ),
      child: SizedBox(
        width: double.infinity,
        height: layouts.writeArticleButtonSize,
        child: GlassButton.custom(
          shape: LiquidRoundedRectangle(
            borderRadius: radiuses.m,
          ),
          onTap: onTap,
          settings: LiquidGlassSettings(
            glassColor: colors.primaryContainer.withAlpha(170),
            // blur: 1
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: colors.onPrimaryContainer,
              ),
              SizedBox(width: spacing.s),
              Text(
                context.l10n.newArticle,
                style: TextStyle(
                  color: colors.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}