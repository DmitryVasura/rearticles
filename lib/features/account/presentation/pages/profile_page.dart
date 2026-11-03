import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/radiuses.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/features/account/domain/entities/user_profile.dart';

class ProfilePage extends StatelessWidget {
  final UserProfile user;

  const new({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profile)),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.layouts.authContentMaxWidth,
          ),
          child: ListView(
            padding: EdgeInsets.all(spacing.m),
            children: [
              Center(
                child: CircleAvatar(
                  radius: context.radiuses.xl,
                  backgroundColor: colors.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: context.radiuses.xl,
                    color: colors.onPrimaryContainer,
                  ),
                ),
              ),
              SizedBox(height: spacing.m),
              Center(
                child: Text(
                  user.username,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(height: spacing.l),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: user.articlesCount,
                      label: context.l10n.articles,
                    ),
                  ),
                  SizedBox(width: spacing.m),
                  Expanded(
                    child: _StatCard(
                      value: user.likesReceived,
                      label: context.l10n.likesReceived,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.l),
              GlassContainer(
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.person_outline,
                      label: context.l10n.username,
                      value: user.username,
                    ),
                    const Divider(height: 1),
                    _InfoRow(
                      icon: Icons.mail_outline,
                      label: context.l10n.email,
                      value: user.email,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final int value;
  final String label;

  const new({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final textTheme = Theme.of(context).textTheme;

    return GlassContainer(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.m,
          vertical: spacing.l,
        ),
        child: Column(
          children: [
            Text('$value', style: textTheme.headlineMedium),
            SizedBox(height: spacing.xs),
            Text(label, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const new({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.all(spacing.m),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: spacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodySmall),
                SizedBox(height: spacing.xs),
                Text(value, style: textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}