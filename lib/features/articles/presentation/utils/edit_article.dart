import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/features/articles/data/models/article_model.dart';
import 'package:re_articles/features/articles/domain/entities/article_draft.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_event.dart';

Future<void> editArticle(BuildContext context, ArticleModel article) async {
  final repository = Injection.draftRepository;
  final draftId = 'edit_${article.id}';

  final existing = await repository.getById(draftId);

  if (existing == null) {
    await repository.save(
      ArticleDraft(
        id: draftId,
        title: article.title,
        content: jsonDecode(article.text) as List<dynamic>,
        updatedAt: DateTime.now(),
        articleId: article.id,
        tags: article.tags.map((tag) => tag.tag).toList(),
        difficulty: article.difficulty,
      ),
    );
  }

  if (!context.mounted) return;

  await Navigator.pushNamed(
    context,
    RouteNames.createArticle,
    arguments: draftId,
  );

  if (context.mounted) {
    context.read<ArticleFeedBloc>().add(const LoadArticles());
  }
}