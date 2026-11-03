import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:re_articles/core/themes/spacing.dart';

enum ArticleDifficality {
  easy('⬠'),
  normal('⬟'),
  medium('⬢'),
  hard('⬣'),
  advanced('✦');

  const ArticleDifficality(this.icon);

  final String icon;

  String localized(AppLocalizations l10n) => switch (this) {
    easy => l10n.difficultyEasy,
    normal => l10n.difficultyNormal,
    medium => l10n.difficultyMedium,
    hard => l10n.difficultyHard,
    advanced => l10n.difficultyAdvanced,
  };
  
  static ArticleDifficality fromName(String? name) =>
    values.asNameMap()[name] ?? normal;
}

class DifficalityWidget extends StatelessWidget {
  final ArticleDifficality difficality;

  const new({super.key, required this.difficality});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineSmall;

    return Row(
      children: [
        Text(difficality.icon, style: style),
        SizedBox(width: context.spacing.s),
        Text(difficality.localized(context.l10n), style: style),
      ],
    );
  }
}