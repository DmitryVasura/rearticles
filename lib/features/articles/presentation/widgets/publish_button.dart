import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/radiuses.dart';
import 'package:re_articles/core/themes/spacing.dart';

class PublishButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isReady;
  final String? label;

  const new({
    super.key, 
    required this.isReady, 
    required this.onTap,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing.m, spacing.s, spacing.m, spacing.m),
      child: SizedBox(
        width: double.infinity,
        height: context.layouts.writeArticleButtonSize,
        child: GlassButton.custom(
          shape: LiquidRoundedRectangle(borderRadius: context.radiuses.m),
          onTap: onTap,
          settings: LiquidGlassSettings(
            glassColor: isReady ? colors.primary.withAlpha(170) : colors.surfaceContainer.withAlpha(170),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.publish),
              SizedBox(width: spacing.s),
              Text(label ?? context.l10n.publishArticle),
            ],
          ),
        ),
      ),
    );
  }
}