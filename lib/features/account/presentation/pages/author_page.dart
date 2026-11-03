import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/radiuses.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/features/account/data/models/author_profile.dart';
import 'package:re_articles/features/account/presentation/pages/author_args.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_event.dart';
import 'package:re_articles/features/articles/presentation/widgets/articles_feed_list.dart';

class AuthorPage extends StatefulWidget {
  final AuthorArgs args;

  const new({super.key, required this.args});

  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  late final Future<AuthorProfile> _profile =
      Injection.userApi.getAuthorProfile(widget.args.id);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.createArticleFeedBloc(authorId: widget.args.id)
        ..add(const LoadArticles()),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.args.name ?? context.l10n.author)),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.layouts.authContentMaxWidth,
            ),
            child: ArticlesFeedList(
              emptyText: context.l10n.noArticlesYet,
              header: _AuthorHeader(
                name: widget.args.name,
                profile: _profile,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthorHeader extends StatelessWidget {
  final String? name;
  final Future<AuthorProfile> profile;

  const new({required this.name, required this.profile});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return FutureBuilder<AuthorProfile>(
      future: profile,
      builder: (context, snapshot) {
        final data = snapshot.data;

        return Padding(
          padding: EdgeInsets.all(spacing.m),
          child: Column(
            children: [
              CircleAvatar(
                radius: context.radiuses.xl,
                backgroundColor: colors.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: context.radiuses.xl,
                  color: colors.onPrimaryContainer,
                ),
              ),
              SizedBox(height: spacing.m),
              Text(
                data?.username ?? name ?? '',
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: spacing.s),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.heart_fill, color: colors.primary),
                  SizedBox(width: spacing.s),
                  Text(
                    data == null ? '–' : '${data.likesReceived}',
                    style: theme.textTheme.headlineMedium,
                  ),
                ],
              ),
              SizedBox(height: spacing.l),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(context.l10n.articles, style: theme.textTheme.titleMedium),
              ),
            ],
          ),
        );
      },
    );
  }
}