import 'package:re_articles/l10n/l10n.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/features/articles/presentation/bloc/drafts/article_draft_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/drafts/article_draft_event.dart';
import 'package:re_articles/features/articles/presentation/bloc/drafts/article_draft_state.dart';

class ArticleWritingPage extends StatelessWidget {
  const ArticleWritingPage({super.key, this.draftId});

  final String? draftId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.createArticleDraftBloc()
        ..add(LoadDraft(id: draftId)),
      child: const ArticleWritingView(),
    );
  }
}

class ArticleWritingView extends StatefulWidget {
  const ArticleWritingView({super.key});

  @override
  State<ArticleWritingView> createState() => _ArticleWritingViewState();
}

class _ArticleWritingViewState extends State<ArticleWritingView> {
  QuillController? _controller;
  TextEditingController? _titleController;

  String? _draftId;
  int? _articleId;
  List<String> _tags = const [];
  String? _difficulty;
  bool _initialized = false;

  @override
  void dispose() {
    _controller?.removeListener(_onContentChanged);
    _controller?.dispose();
    _titleController?.dispose();
    super.dispose();
  }

  void _initializeDraft(ArticleDraftLoaded state) {
    if (_initialized) return;

    final draft = state.draft;
    final document = Document.fromJson(draft.content);

    _draftId = draft.id;
    _articleId = draft.articleId;
    _tags = draft.tags;
    _difficulty = draft.difficulty;

    _controller = QuillController(
      document: document,
      selection: TextSelection.collapsed(
        offset: document.length - 1,
      ),
    );

    _titleController = TextEditingController(
      text: draft.title,
    );

    _controller!.addListener(_onContentChanged);

    _initialized = true;
    setState(() {});
  }

  void _onContentChanged() {
    _saveDraftChanges();
  }

  void _saveDraftChanges() {
    if (!_initialized || _draftId == null) return;

    context.read<ArticleDraftBloc>().add(
      DraftChanged(
        id: _draftId!,
        title: _titleController!.text,
        content: _controller!.document.toDelta().toJson(),
      ),
    );
  }

  void onSave() {
    final delta = _controller!.document.toDelta().toJson();

    final article = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': _titleController!.text.trim(),
      'text': jsonEncode(delta),
      'likes': 0,
      'views': 0,
      'tags': _tags,
      'difficulty': _difficulty,
      'draftId': _draftId,
      'articleId': _articleId,
    };

    Navigator.pushNamed(
      context,
      RouteNames.finishWriting,
      arguments: article,
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = Theme.of(context).colorScheme;
    final layouts = context.layouts;

    return BlocListener<ArticleDraftBloc, ArticleDraftState>(
      listener: (context, state) {
        if (state is ArticleDraftLoaded) {
          _initializeDraft(state);
        }
      },
      child: !_initialized
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                toolbarHeight: layouts.toolbarHeight,
                backgroundColor: colors.surface,
                surfaceTintColor: colors.surface,
                title: Text(_articleId == null ? context.l10n.writeArticle : context.l10n.editArticle),
                actions: [
                  Padding(
                    padding: EdgeInsets.all(spacing.xs),
                    child: SizedBox(
                      width: layouts.doneButton,
                      height: layouts.doneButton,
                      child: GlassIconButton(
                        size: layouts.doneButton,
                        icon: Icon(
                          Icons.done,
                          color: colors.onPrimaryContainer,
                        ),
                        onPressed: onSave,
                        settings: LiquidGlassSettings(
                          glassColor: colors.primaryContainer.withAlpha(170),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.m,
                  vertical: spacing.s,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      onChanged: (_) => _saveDraftChanges(),
                      decoration: InputDecoration(
                        hintText: context.l10n.articleTitleHint,
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    SizedBox(height: spacing.s),

                    Expanded(
                      child: GlassContainer(
                        child: Padding(
                          padding: EdgeInsets.all(spacing.m),
                          child: QuillEditor.basic(
                            controller: _controller!,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: spacing.m),

                    GlassContainer(
                      settings: LiquidGlassSettings(
                        blur: 3,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(spacing.s),
                        child: QuillSimpleToolbar(
                          controller: _controller!,
                          config: const QuillSimpleToolbarConfig(
                            multiRowsDisplay: false,
                            showFontFamily: false,
                            showListCheck: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}