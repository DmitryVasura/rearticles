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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onLoginTapped() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final layouts = context.layouts;

    final mediaQuery = MediaQuery.of(context);

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
              child: SingleChildScrollView(
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
                            icon: Icons.person,
                            text: context.l10n.createAnAccount,
                          ),

                          SizedBox(height: spacing.l),

                          _TextFields(
                            emailController: emailController,
                            loginController: loginController,
                            passwordController: passwordController,
                          ),

                          SizedBox(height: spacing.l),

                          _RegisterButtons(
                            isLoading: isLoading,
                            onRegisterTapped: () {
                              context.read<AuthBloc>().add(
                                RegisterRequested(
                                  username: loginController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                            },
                            onLoginTapped: onLoginTapped,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TextFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController loginController;
  final TextEditingController passwordController;

  const _TextFields({
    required this.emailController,
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
            controller: emailController,
            placeholder: context.l10n.email,
            settings: LiquidGlassSettings(
              visibility: 3,
            ),
          ),
        ),

        SizedBox(height: spacing.s),

        SizedBox(
          height: layouts.authFieldHeight,
          child: GlassTextField(
            controller: loginController,
            placeholder: context.l10n.loginName,
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

class _RegisterButtons extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onRegisterTapped;
  final VoidCallback onLoginTapped;

  const _RegisterButtons({
    required this.isLoading,
    required this.onRegisterTapped,
    required this.onLoginTapped,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Column(
      children: [
        AuthPrimaryButton(
          text: context.l10n.createAccount,
          isLoading: isLoading,
          onTap: onRegisterTapped,
        ),

        SizedBox(height: spacing.s),

        AuthSwitchText(
          text: context.l10n.alreadyHaveAccount,
          actionText: context.l10n.logIn,
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}