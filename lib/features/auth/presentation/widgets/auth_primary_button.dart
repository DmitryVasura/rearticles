import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/radiuses.dart';

class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onTap;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final layouts = context.layouts;
    final radiuses = context.radiuses;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textStyle = theme.textTheme;

    return IgnorePointer(
      ignoring: isLoading,
      child: GlassButton.custom(
        height: layouts.loginButtonSize,
        width: double.infinity,
        onTap: onTap,
        shape: LiquidRoundedRectangle(
          borderRadius: radiuses.m,
        ),
        settings: LiquidGlassSettings(
          glassColor: colors.primary,
          lightIntensity: 1.3,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colors.onPrimaryContainer,
                ),
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: textStyle.headlineMedium?.copyWith(
                  color: colors.onPrimaryContainer,
                ),
              ),
      ),
    );
  }
}