import 'package:re_articles/l10n/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/widgets/feedback/glass_progress_indicator.dart';
import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/spacing.dart';

class LoadingPage extends StatefulWidget {
  const new({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final route = await _resolveStartRoute();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
  }

  Future<String> _resolveStartRoute() async {
    final storage = Injection.tokenStorage;
    final token = await storage.getToken();

    if (token == null || token.isEmpty) return RouteNames.login;

    try {
      await Injection.userApi.getCurrentUser(tokenStorage: storage);
      return RouteNames.main;
    } on DioException catch (e) {
      final status = e.response?.statusCode;

      if (status == 401 || status == 404) {
        await storage.deleteToken();
        return RouteNames.login;
      }

      return RouteNames.main;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const _LoadingWidget();
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.loading),
              SizedBox(height: context.spacing.m),
              GlassProgressIndicator.circular(
                size: context.layouts.loadingSize,
                color: colors.primaryContainer,
                backgroundColor: colors.surfaceContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}