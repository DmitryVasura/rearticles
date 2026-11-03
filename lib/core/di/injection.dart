import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:re_articles/core/network/api_client.dart';
import 'package:re_articles/core/storage/token_storage.dart';
import 'package:re_articles/features/account/data/datasources/user_api.dart';
import 'package:re_articles/features/account/data/repositories/user_repository_impl.dart';
import 'package:re_articles/features/account/domain/repositories/user_repository.dart';
import 'package:re_articles/features/account/domain/usecases/get_current_user.dart';
import 'package:re_articles/features/account/domain/usecases/log_out.dart';
import 'package:re_articles/features/account/presentation/bloc/account_bloc.dart';
import 'package:re_articles/features/articles/data/datasources/article_api.dart';
import 'package:re_articles/features/articles/data/datasources/local_draft_storage.dart';
import 'package:re_articles/features/articles/data/datasources/tag_api.dart';
import 'package:re_articles/features/articles/data/repositories/article_repository_impl.dart';
import 'package:re_articles/features/articles/data/repositories/draft_repository_impl.dart';
import 'package:re_articles/features/articles/data/repositories/tag_repository_impl.dart';
import 'package:re_articles/features/articles/domain/entities/article_scope.dart';
import 'package:re_articles/features/articles/domain/repositories/article_repository.dart';
import 'package:re_articles/features/articles/domain/repositories/draft_repository.dart';
import 'package:re_articles/features/articles/domain/repositories/tag_repository.dart';
import 'package:re_articles/features/articles/domain/usecases/delete_article.dart';
import 'package:re_articles/features/articles/domain/usecases/get_articles.dart';
import 'package:re_articles/features/articles/domain/usecases/like_article.dart';
import 'package:re_articles/features/articles/domain/usecases/publish_article.dart';
import 'package:re_articles/features/articles/domain/usecases/update_article.dart';
import 'package:re_articles/features/articles/presentation/bloc/drafts/article_draft_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/articles/article_feed_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/publish/article_publish_bloc.dart';
import 'package:re_articles/features/articles/presentation/bloc/tags/tag_bloc.dart';

import 'package:re_articles/features/auth/data/datasources/auth_api.dart';
import 'package:re_articles/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:re_articles/features/auth/domain/repositories/auth_repository.dart';

import 'package:re_articles/features/auth/domain/usecases/login.dart';
import 'package:re_articles/features/auth/domain/usecases/register.dart';
import 'package:re_articles/features/auth/domain/usecases/validate_email.dart';
import 'package:re_articles/features/auth/domain/usecases/validate_password.dart';
import 'package:re_articles/features/auth/domain/usecases/validate_username.dart';

import 'package:re_articles/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:re_articles/features/settings/data/settings_storage.dart';
import 'package:re_articles/features/settings/presentation/cubit/settings_cubit.dart';

class Injection {
  static final ApiClient apiClient = ApiClient(tokenStorage);

  static const FlutterSecureStorage secureStorage =
      FlutterSecureStorage();

  static final TokenStorage tokenStorage = TokenStorage(
    secureStorage,
  );
  
  static final SettingsCubit settingsCubit = SettingsCubit(
    SettingsStorage(Hive.box('settings')),
  );
  
  static final AuthApi authApi = AuthApi(
    apiClient.dio,
  );

  static final AuthRepository authRepository = AuthRepositoryImpl(
    authApi,
  );

  static final UserApi userApi = UserApi(
    apiClient.dio
  );
  
  static final UserRepository userRepository = UserRepositoryImpl(
    userApi,
    tokenStorage
  );

  static final ArticleApi articleApi = ArticleApi(apiClient.dio);

  static final TagApi tagApi = TagApi(
    apiClient.dio,
  );

  static final TagRepository tagRepository = TagRepositoryImpl(
    tagApi,
  );

  static final ArticleRepository articleRepository =
      ArticleRepositoryImpl(
    articleApi,
  );

  static final LocalDraftStorage localDraftStorage =
      LocalDraftStorage(
    Hive.box<String>('article_drafts'),
  );

  static final DraftRepository draftRepository =
      DraftRepositoryImpl(localDraftStorage);

  static ArticleDraftBloc createArticleDraftBloc() {
    return ArticleDraftBloc(draftRepository);
  }

  static AuthBloc createAuthBloc() {
    return AuthBloc(
      login: Login(authRepository),
      register: Register(authRepository),
      validateEmail: ValidateEmail(),
      validateUsername: ValidateUsername(),
      validatePassword: ValidatePassword(),
      tokenStorage: tokenStorage,
    );
  }

  static AccountBloc createAccountBloc() {
    return AccountBloc(
      GetCurrentUser(
        userRepository
      ),
      LogOut(
        userRepository
      )
    );
  }
  
  static ArticleFeedBloc createArticleFeedBloc({
    ArticleScope scope = ArticleScope.all,
    int? authorId,
  }) {
    return ArticleFeedBloc(
      GetArticles(articleRepository),
      LikeArticle(articleRepository),
      DeleteArticle(articleRepository),
      scope: scope,
      authorId: authorId,
    );
  }

  static ArticlePublishBloc createArticlePublishBloc() {
    return ArticlePublishBloc(
      PublishArticle(articleRepository),
      UpdateArticle(articleRepository),
      draftRepository,
    );
  }

  static TagBloc createTagBloc() => TagBloc(tagRepository);
}