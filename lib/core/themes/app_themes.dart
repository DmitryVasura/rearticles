import 'package:flutter/material.dart';
import 'package:re_articles/core/themes/app_breakpoints.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/dark_theme.dart';
import 'package:re_articles/core/themes/light_theme.dart';
import 'package:re_articles/core/themes/radiuses.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/features/settings/domain/entities/app_settings.dart';

class AppThemes {
  static ThemeData light(BuildContext context, UiSize size) =>
      _build(lightTheme, context, size);

  static ThemeData dark(BuildContext context, UiSize size) =>
      _build(darkTheme, context, size);

  static ThemeData _build(ThemeData base, BuildContext context, UiSize size) {
    final resolved = size == UiSize.auto
        ? _sizeForWidth(MediaQuery.sizeOf(context).width)
        : size;

    return base.copyWith(
      extensions: <ThemeExtension<dynamic>>[
        _spacing(resolved),
        AppRadiuses.regular(),
        _layouts(resolved),
      ],
    );
  }

  static UiSize _sizeForWidth(double width) {
    if (width <= AppBreakpoints.compact) return UiSize.compact;
    if (width >= AppBreakpoints.wide) return UiSize.large;
    return UiSize.regular;
  }

  static AppSpacing _spacing(UiSize size) => switch (size) {
        UiSize.compact => AppSpacing.compact(),
        UiSize.large => AppSpacing.large(),
        _ => AppSpacing.regular(),
      };

  static AppLayouts _layouts(UiSize size) => switch (size) {
        UiSize.compact => AppLayouts.compact(),
        UiSize.large => AppLayouts.large(),
        _ => AppLayouts.regular(),
      };
}