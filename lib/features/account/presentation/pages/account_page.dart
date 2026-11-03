import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/core/themes/radiuses.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/core/utils/haptics.dart';
import 'package:re_articles/features/account/presentation/bloc/account_bloc.dart';
import 'package:re_articles/features/account/presentation/bloc/account_event.dart';
import 'package:re_articles/features/account/presentation/bloc/account_state.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final spacing = context.spacing;
    final radiuses = context.radiuses;

    // .value, потому что блок создан выше (в роуте) и не принадлежит этой странице.
    return BlocProvider.value(
      value: context.read<AccountBloc>()..add(const GetCurrentUserEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.account)),
        body: BlocListener<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is LogedOut) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.login,
                (route) => false,
              );
            }
          },
          child: BlocBuilder<AccountBloc, AccountState>(
            builder: (context, state) {
              if (state is AccountLoading || state is LoginOut) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AccountError) {
                return Center(
                  child: Text(state.message, textAlign: TextAlign.center),
                );
              }

              if (state is AccountLoaded) {
                final user = state.result.user;

                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.all(spacing.m),
                      sliver: SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: radiuses.xl,
                                  backgroundColor: colors.primaryContainer,
                                  child: Icon(
                                    Icons.person,
                                    size: radiuses.xl,
                                    color: colors.onPrimaryContainer,
                                  ),
                                ),
                                SizedBox(height: spacing.s),
                                Text(
                                  user.username,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                                SizedBox(height: spacing.m),
                                AccountTile(
                                  title: context.l10n.profile,
                                  icon: Icons.person_outline,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RouteNames.profile,
                                    arguments: user,
                                  ),
                                ),
                                AccountTile(
                                  title: context.l10n.myArticles,
                                  icon: Icons.article_outlined,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RouteNames.myArticles,
                                  ),
                                ),
                                AccountTile(
                                  title: context.l10n.likedArticles,
                                  icon: Icons.favorite_border,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RouteNames.likedArticles,
                                  ),
                                ),
                              ],
                            ),
                            AccountTile(
                              title: context.l10n.logOut,
                              icon: Icons.logout,
                              onTap: () {
                                Haptics.medium();
                                context
                                    .read<AccountBloc>()
                                    .add(const LogOutEvent());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class AccountTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const AccountTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radiuses = context.radiuses;
    final spacing = context.spacing;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.s),
      child: GlassButton.custom(
        onTap: () {
          Haptics.light();
          onTap();
        },
        label: title,
        shape: LiquidRoundedRectangle(borderRadius: radiuses.m),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.m,
            vertical: spacing.m,
          ),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(width: spacing.xs),
              Expanded(child: Text(title)),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}