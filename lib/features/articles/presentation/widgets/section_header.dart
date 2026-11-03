import 'package:flutter/material.dart';
import 'package:re_articles/core/themes/spacing.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: spacing.s),
          trailing!,
        ],
      ],
    );
  }
}