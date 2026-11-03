import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/themes/radiuses.dart';
import 'package:re_articles/features/articles/presentation/widgets/difficulty_widget.dart';

class DifficultyPicker extends StatelessWidget {
  final ArticleDifficality value;
  final ValueChanged<ArticleDifficality> onChanged;

  const new({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = context.l10n;

    return GlassPullDownButton(
      buttonWidth: double.infinity,
      label: '${value.icon}  ${value.localized(l10n)}',
      buttonShape: LiquidRoundedRectangle(borderRadius: context.radiuses.m),
      items: [
        for (final d in ArticleDifficality.values)
          GlassMenuItem(
            title: '${d.icon}  ${d.localized(l10n)}',
            trailing: d == value
                ? Icon(Icons.check, color: colors.primary)
                : null,
            onTap: () => onChanged(d),
          ),
      ],
    );
  }
}