import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/core/utils/haptics.dart';
import 'package:re_articles/features/articles/presentation/bloc/publish/article_publish_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/publish/article_publish_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/publish/article_publish_state.dart';
import 'package:re_articles/features/articles/presentation/bloc/tags/tag_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/tags/tag_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/tags/tag_state.dart';
import 'package:re_articles/features/articles/presentation/widgets/difficulty_picker.dart';
import 'package:re_articles/features/articles/presentation/widgets/difficulty_widget.dart';
import 'package:re_articles/features/articles/presentation/widgets/publish_button.dart';
import 'package:re_articles/features/articles/presentation/widgets/publish_tags_section.dart';
import 'package:re_articles/features/articles/presentation/widgets/section_header.dart';

class ArticlePublishPage extends StatefulWidget {
  final Map<String, dynamic> article;

  const new({super.key, required this.article});

  @override
  State<ArticlePublishPage> createState() => _ArticlePublishPageState();
}

class _ArticlePublishPageState extends State<ArticlePublishPage> {
  static const _minTags = 1;
  static const _maxTags = 5;

  late final TagBloc _tagBloc;
  late final ArticlePublishBloc _publishBloc;

  final _selectedTags = <String>{};
  final _searchController = TextEditingController();
  var _difficulty = ArticleDifficality.normal;

  bool get _hasTitle =>
      (widget.article['title'] as String? ?? '').trim().isNotEmpty;

  bool get _isReady => _hasTitle && _selectedTags.length >= _minTags;
  int? get _articleId => widget.article['articleId'] as int?;
  bool get _isEdit => _articleId != null;

  @override
  void initState() {
    super.initState();
    _tagBloc = Injection.createTagBloc()..add(const LoadTags());
    _publishBloc = Injection.createArticlePublishBloc();

    final initialTags = widget.article['tags'];
    if (initialTags is List) {
      _selectedTags.addAll(initialTags.whereType<String>());
    }

    final initialDifficulty = widget.article['difficulty'] as String?;
    if (initialDifficulty != null) {
      _difficulty = ArticleDifficality.fromName(initialDifficulty);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tagBloc.close();
    _publishBloc.close();
    super.dispose();
  }

  void _toggleTag(String name, bool select) {
    if (select && _selectedTags.length >= _maxTags) {
      Haptics.error();
      _showMessage(context.l10n.maxTagsError(_maxTags));
      return;
    }

    Haptics.selection();

    setState(() {
      select ? _selectedTags.add(name) : _selectedTags.remove(name);
    });
  }

  void _createTag(String name) {
    if (_selectedTags.length >= _maxTags) {
      Haptics.error();
      _showMessage(context.l10n.maxTagsError(_maxTags));
      return;
    }
    _tagBloc.add(CreateTag(name));
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _publish() {
    if (!_isReady) {
      Haptics.error();
      _showMessage(
        _hasTitle
            ? context.l10n.minTagsError(_minTags)
            : context.l10n.needTitle,
      );
      return;
    }

    _publishBloc.add(
      PublishArticleRequested(
        title: widget.article['title'] as String,
        text: widget.article['text'] as String,
        tags: _selectedTags.toList(),
        difficulty: _difficulty.name,
        draftId: widget.article['draftId'] as String?,
        articleId: _articleId
      ),
    );
  }

  void _onPublishStateChanged(
    BuildContext context,
    ArticlePublishState state,
  ) {
    switch (state) {
      case ArticlePublished():
        Haptics.success();

        final messenger = ScaffoldMessenger.of(context);

        Navigator.of(context).popUntil(
          (route) =>
              route.isFirst ||
              (_isEdit && route.settings.name == RouteNames.myArticles),
        );

        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                _isEdit
                    ? context.l10n.articleUpdated
                    : context.l10n.articlePublished,
              ),
            ),
          );
      case ArticlePublishFailure(:final message):
        Haptics.error();
        _showMessage(message);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _tagBloc,
      child: BlocListener<TagBloc, TagState>(
        listenWhen: (_, state) =>
            state is TagsLoaded &&
            (state.created != null || state.error != null),
        listener: (context, state) {
          if (state is! TagsLoaded) return;

          final created = state.created;
          if (created != null) {
            _toggleTag(created.name, true);
            _searchController.clear();
          } else if (state.error != null) {
            _showMessage(state.error!);
          }
        },
        child: BlocListener<ArticlePublishBloc, ArticlePublishState>(
          bloc: _publishBloc,
          listener: _onPublishStateChanged,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                _isEdit
                    ? context.l10n.editArticleTitle
                    : context.l10n.publishArticleTitle,
              ),
            ),
            body: SafeArea(
              top: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: context.layouts.authContentMaxWidth,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(spacing.m),
                          children: [
                            Text(
                              context.l10n.publishIntro,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    theme.colorScheme.onSurface.withAlpha(160),
                              ),
                            ),
                            SizedBox(height: spacing.xl),
                            SectionHeader(
                              title: context.l10n.difficulty,
                              subtitle: context.l10n.difficultySubtitle,
                            ),
                            SizedBox(height: spacing.m),
                            DifficultyPicker(
                              value: _difficulty,
                              onChanged: (d) {
                                Haptics.selection();
                                setState(() => _difficulty = d);
                              },
                            ),
                            SizedBox(height: spacing.xl),
                            SectionHeader(
                              title: context.l10n.tags,
                              subtitle: context.l10n.tagsSubtitle,
                              trailing: Text(
                                '${_selectedTags.length}/$_maxTags',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            SizedBox(height: spacing.m),
                            PublishTagsSection(
                              controller: _searchController,
                              selected: _selectedTags,
                              onRemove: (t) =>
                                  setState(() => _selectedTags.remove(t)),
                              onToggle: _toggleTag,
                              onCreate: _createTag,
                            ),
                            SizedBox(height: spacing.xl),
                          ],
                        ),
                      ),
                      BlocBuilder<ArticlePublishBloc, ArticlePublishState>(
                        bloc: _publishBloc,
                        builder: (context, state) => PublishButton(
                          label: _isEdit
                              ? context.l10n.saveChanges
                              : context.l10n.publishArticle,
                          isReady: _isReady && state is! ArticlePublishing,
                          onTap: _publish,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}