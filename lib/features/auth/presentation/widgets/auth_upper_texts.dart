import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/spacing.dart';

class AuthUpperTexts extends StatelessWidget {
  final IconData icon;
  final String text;
  const new({
    super.key,
    required this.icon,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final spacing = context.spacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: context.layouts.authIconSize,
        ),
        SizedBox(height: spacing.s,),
        Text(
          text,
          textAlign: TextAlign.center,
          style: textStyles.headlineLarge,
        ),
        SizedBox(height: spacing.s,),
        Text(
          context.l10n.welcomeMessage,
          style: textStyles.bodySmall,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}