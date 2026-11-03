import 'package:re_articles/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/routes/route_names.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/spacing.dart';

import 'package:re_articles/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:re_articles/features/auth/presentation/bloc/auth_event.dart';
import 'package:re_articles/features/auth/presentation/bloc/auth_state.dart';
import 'package:re_articles/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:re_articles/features/auth/presentation/widgets/auth_switch_text.dart';
import 'package:re_articles/features/auth/presentation/widgets/auth_upper_texts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onRegisterTapped() {
    Navigator.pushNamed(
      context,
      RouteNames.createAccount,
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => Injection.createAuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteNames.main,
              (route) => false,
            );
          }

          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: _MainBodyContent(
                isLoading: isLoading,
                loginController: loginController,
                passwordController: passwordController,
                onLoginTapped: () {
                  context.read<AuthBloc>().add(
                    LoginRequested(
                      email: loginController.text,
                      password: passwordController.text,
                    ),
                  );
                },
                onRegisterTapped: onRegisterTapped,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MainBodyContent extends StatelessWidget {
  final TextEditingController loginController;
  final TextEditingController passwordController;
  final bool isLoading;
  final void Function() onLoginTapped;
  final void Function() onRegisterTapped;

  const new({
    required this.isLoading,
    required this.loginController,
    required this.onLoginTapped,
    required this.onRegisterTapped,
    required this.passwordController
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final layouts = context.layouts;

    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.m),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: mediaQuery.size.height -
              mediaQuery.padding.vertical -
              spacing.m * 2,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: layouts.authContentMaxWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthUpperTexts(
                  icon: Icons.lock_open,
                  text: context.l10n.logIn,
                ),

                SizedBox(height: spacing.l),

                _TextFields(
                  loginController: loginController,
                  passwordController: passwordController,
                ),

                SizedBox(height: spacing.l),

                _LoginButtons(
                  isLoading: isLoading,
                  onLoginTapped: onLoginTapped,
                  onRegisterTapped: onRegisterTapped,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextFields extends StatelessWidget {
  final TextEditingController loginController;
  final TextEditingController passwordController;

  const _TextFields({
    required this.loginController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final layouts = context.layouts;

    return Column(
      children: [
        SizedBox(
          height: layouts.authFieldHeight,
          child: GlassTextField(
            controller: loginController,
            placeholder: context.l10n.email,
            settings: LiquidGlassSettings(
              visibility: 3,
            ),
          ),
        ),

        SizedBox(height: spacing.s),

        SizedBox(
          height: layouts.authFieldHeight,
          child: GlassPasswordField(
            controller: passwordController,
            settings: LiquidGlassSettings(
              visibility: 3,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRegisterTapped;
  final VoidCallback onLoginTapped;

  const _LoginButtons({
    required this.isLoading,
    required this.onLoginTapped,
    required this.onRegisterTapped,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      children: [
        AuthPrimaryButton(
          text: context.l10n.logIn,
          isLoading: isLoading,
          onTap: onLoginTapped,
        ),

        SizedBox(height: spacing.s),

        AuthSwitchText(
          text: context.l10n.noAccountYet,
          actionText: context.l10n.register,
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteNames.createAccount,
            );
          },
        ),
      ],
    );
  }
}