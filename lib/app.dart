import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/core/routes/routes.dart';
import 'package:re_articles/core/themes/app_themes.dart';
import 'package:re_articles/features/settings/domain/entities/app_settings.dart';
import 'package:re_articles/l10n/l10n.dart';
import 'package:re_articles/features/settings/presentation/cubit/settings_cubit.dart';

class ReArticles extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: Injection.settingsCubit,
      child: BlocBuilder<SettingsCubit, AppSettings>(
        builder: (context, settings) => MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.onGenerateRoute,
          theme: AppThemes.light(context, settings.uiSize),
          darkTheme: AppThemes.dark(context, settings.uiSize),
          themeMode: settings.themeMode,
          initialRoute: RouteNames.loading,

          locale: settings.locale,

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],

          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}