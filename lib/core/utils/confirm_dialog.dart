import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';

Future<bool> confirmDestructive(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(dialogContext.l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(
            confirmLabel ?? dialogContext.l10n.delete,
            style: TextStyle(
              color: Theme.of(dialogContext).colorScheme.error,
            ),
          ),
        ),
      ],
    ),
  );

  return result ?? false;
}