import 'package:re_articles/l10n/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/core/utils/haptics.dart';
import 'package:re_articles/features/articles/domain/entities/report_reason.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_event.dart';

void _showMessage(
  ScaffoldMessengerState messenger,
  String text, {
  SnackBarAction? action,
}) {
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), action: action));
}

// Сообщение сервера, если оно есть, иначе запасной текст.
String _errorText(Object error, String fallback) {
  if (error is DioException) {
    final data = error.response?.data;

    if (data is Map && data['error'] is String) {
      return data['error'] as String;
    }
  }

  return fallback;
}

Future<ReportReason?> _pickReason(BuildContext context) {
  return showModalBottomSheet<ReportReason>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(sheetContext.spacing.m),
            child: Text(
              sheetContext.l10n.reportWhy,
              style: Theme.of(sheetContext).textTheme.titleMedium,
            ),
          ),
          for (final reason in ReportReason.values)
            ListTile(
              title: Text(reason.localized(sheetContext.l10n)),
              onTap: () => Navigator.pop(sheetContext, reason),
            ),
        ],
      ),
    ),
  );
}

/// «Don't like»: скрываем сразу, а при ошибке возвращаем.
/// [onHidden] вызывается после успеха (например, закрыть страницу статьи).
Future<void> dislikeArticle(
  BuildContext context,
  int articleId, {
  VoidCallback? onHidden,
}) async {
  final bloc = context.read<ArticleFeedBloc>();
  final messenger = ScaffoldMessenger.of(context);
  final api = Injection.articleApi;
  final l10n = context.l10n;

  Haptics.medium();
  bloc.add(HideArticleEvent(articleId: articleId));

  try {
    await api.setDislike(articleId: articleId, disliked: true);
  } catch (error) {
    bloc.add(const RestoreHiddenArticleEvent());
    _showMessage(
      messenger,
      _errorText(error, l10n.hideFailed),
    );
    return;
  }

  onHidden?.call();

  _showMessage(
    messenger,
    l10n.fewerLikeThis,
    action: SnackBarAction(
      label: l10n.undo,
      onPressed: () async {
        try {
          await api.setDislike(articleId: articleId, disliked: false);
          bloc.add(const RestoreHiddenArticleEvent());
        } catch (_) {}
      },
    ),
  );
}

/// «Report»: выбор причины, отправка, скрытие у себя.
Future<void> reportArticle(
  BuildContext context,
  int articleId, {
  VoidCallback? onHidden,
}) async {
  final bloc = context.read<ArticleFeedBloc>();
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;

  final reason = await _pickReason(context);

  if (reason == null) return;

  try {
    await Injection.articleApi.reportArticle(
      articleId: articleId,
      reason: reason.name,
    );
  } catch (error) {
    _showMessage(
      messenger,
      _errorText(error, l10n.reportFailed),
    );
    return;
  }

  Haptics.success();
  bloc.add(HideArticleEvent(articleId: articleId));
  onHidden?.call();

  _showMessage(messenger, l10n.reportThanks);
}