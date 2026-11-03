import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/core/di/injection.dart';

import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/features/account/presentation/pages/author_args.dart';
import 'package:re_articles/features/account/presentation/pages/author_page.dart';

import 'package:re_articles/features/articles/domain/entities/article_scope.dart';
import 'package:re_articles/features/articles/presentation/pages/article_details_args.dart';
import 'package:re_articles/features/articles/presentation/pages/article_publish_page.dart';

import 'package:re_articles/features/articles/presentation/pages/article_writing_page.dart';
import 'package:re_articles/features/articles/presentation/pages/articles_details.dart';
import 'package:re_articles/features/articles/presentation/pages/choose_what_to_write.dart';
import 'package:re_articles/features/articles/presentation/pages/scoped_articles_page.dart';
import 'package:re_articles/features/auth/presentation/pages/loading_page.dart';

import 'package:re_articles/features/auth/presentation/pages/login_page.dart';
import 'package:re_articles/features/auth/presentation/pages/register_page.dart';

import 'package:re_articles/features/account/domain/entities/user_profile.dart';
import 'package:re_articles/features/account/presentation/pages/account_page.dart';
import 'package:re_articles/features/account/presentation/pages/profile_page.dart';
import 'package:re_articles/features/settings/presentation/pages/settings_page.dart';

import 'package:re_articles/features/main_page.dart';

class Routes {
  Routes._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.loading:
        return MaterialPageRoute(
          builder: (_) => LoadingPage(),
          settings: settings,
        );

      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => Injection.createAuthBloc(),
            child: const LoginPage(),
          ),
          settings: settings,
        );

      case RouteNames.createAccount:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => Injection.createAuthBloc(),
            child: const RegisterPage(),
          ),
          settings: settings,
        );

      case RouteNames.main:
        return MaterialPageRoute(
          builder: (_) => const MainPage(),
          settings: settings,
        );

      case RouteNames.chooseWhatToWrite:
        return MaterialPageRoute(
          builder: (_) => const ChooseWhatToWrite(),
          settings: settings,
        );

      case RouteNames.author:
        final args = settings.arguments;

        if (args is! AuthorArgs) {
          return _errorRoute('AuthorArgs was not provided');
        }

        return MaterialPageRoute(
          builder: (_) => AuthorPage(args: args),
          settings: settings,
        );

      case RouteNames.createArticle:
        final arguments = settings.arguments;

        if (arguments != null && arguments is! String) {
          return _errorRoute(
            'Expected draft ID as a String',
          );
        }

        return MaterialPageRoute(
          builder: (_) => ArticleWritingPage(
            draftId: arguments as String?,
          ),
          settings: settings,
        );

      case RouteNames.finishWriting:
        final article = settings.arguments;

        if (article is! Map<String, dynamic>) {
          return _errorRoute(
            'Article data was not provided',
          );
        }

        return MaterialPageRoute(
          builder: (_) => ArticlePublishPage(
            article: article,
          ),
          settings: settings,
        );

      case RouteNames.articleDetails:
        final args = settings.arguments;

        if (args is! ArticleDetailsArgs) {
          return _errorRoute(
            'ArticleDetailsArgs was not provided',
          );
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: args.bloc,
            child: ArticlesDetails(article: args.article),
          ),
          settings: settings,
        );

      case RouteNames.account:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => Injection.createAccountBloc(),
            child: const AccountPage(),
          ),
          settings: settings,
        );

      case RouteNames.profile:
        final user = settings.arguments;

        if (user is! UserProfile) {
          return _errorRoute(
            'UserProfile was not provided',
          );
        }

        return MaterialPageRoute(
          builder: (_) => ProfilePage(user: user),
          settings: settings,
        );

      case RouteNames.myArticles:
        return MaterialPageRoute(
          builder: (context) => ScopedArticlesPage(
            title: context.l10n.myArticles,
            scope: ArticleScope.mine,
            emptyText: context.l10n.noPublishedYet,
          ),
          settings: settings,
        );

      case RouteNames.likedArticles:
        return MaterialPageRoute(
          builder: (context) => ScopedArticlesPage(
            title: context.l10n.likedArticles,
            scope: ArticleScope.liked,
            emptyText: context.l10n.likedWillAppear,
          ),
          settings: settings,
        );

      case RouteNames.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );

      default:
        return _errorRoute(
          'Route not found: ${settings.name}',
        );
    }
  }

  static MaterialPageRoute _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.error),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}