import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AppLayouts extends ThemeExtension<AppLayouts> {
  final double loadingSize;

  final double authIconSize;
  final double authContentMaxWidth;
  final double authFieldHeight;
  final double loginButtonSize;
  final double doneButton;

  final double authorIconSize;
  final double tagHeight;
  final double articleMaxHeigth;

  final double writeArticleButtonSize;
  final double toolbarHeight;

  final double articleContentMaxWidth;

  const AppLayouts({
    required this.loadingSize,
    required this.authIconSize,
    required this.authContentMaxWidth,
    required this.authFieldHeight,
    required this.loginButtonSize,
    required this.authorIconSize,
    required this.tagHeight,
    required this.articleMaxHeigth,
    required this.writeArticleButtonSize,
    required this.doneButton,
    required this.toolbarHeight,
    required this.articleContentMaxWidth
  });

  factory AppLayouts.regular() => const AppLayouts(
        loadingSize: 30,

        authIconSize: 150,
        authContentMaxWidth: 500,
        authFieldHeight: 50,
        loginButtonSize: 50,

        authorIconSize: 50,
        tagHeight: 32,
        articleMaxHeigth: 400,
        doneButton: 50,

        writeArticleButtonSize: 50,
        toolbarHeight: 64,

        articleContentMaxWidth: 680
      );

  factory AppLayouts.compact() => const AppLayouts(
        loadingSize: 15,

        authIconSize: 110,
        authContentMaxWidth: 420,
        authFieldHeight: 44,
        loginButtonSize: 44,

        authorIconSize: 40,
        tagHeight: 25,
        articleMaxHeigth: 300,

        writeArticleButtonSize: 44,
        doneButton: 30,
        toolbarHeight: 48,

        articleContentMaxWidth: 560
      );

  factory AppLayouts.large() => const AppLayouts(
        loadingSize: 60,

        authIconSize: 200,
        authContentMaxWidth: 600,
        authFieldHeight: 56,
        loginButtonSize: 56,

        authorIconSize: 65,
        tagHeight: 40,
        articleMaxHeigth: 500,

        writeArticleButtonSize: 56,
        doneButton: 50,
        toolbarHeight: 72,

        articleContentMaxWidth: 760
      );

  @override
  AppLayouts copyWith({
    double? loadingSize,
    double? authIconSize,
    double? authContentMaxWidth,
    double? authFieldHeight,
    double? loginButtonSize,
    double? authorIconSize,
    double? tagHeight,
    double? articleMaxHeigth,
    double? writeArticleButtonSize,
    double? doneButton,
    double? toolbarHeight,
    double? articleContentMaxWidth
  }) {
    return AppLayouts(
      loadingSize: loadingSize ?? this.loadingSize,

      authIconSize: authIconSize ?? this.authIconSize,
      authContentMaxWidth:
          authContentMaxWidth ?? this.authContentMaxWidth,
      authFieldHeight:
          authFieldHeight ?? this.authFieldHeight,
      loginButtonSize:
          loginButtonSize ?? this.loginButtonSize,

      authorIconSize:
          authorIconSize ?? this.authorIconSize,
      tagHeight:
          tagHeight ?? this.tagHeight,
      articleMaxHeigth:
          articleMaxHeigth ?? this.articleMaxHeigth,

      writeArticleButtonSize:
          writeArticleButtonSize ??
          this.writeArticleButtonSize,
      doneButton: doneButton ?? this.doneButton,
      toolbarHeight: toolbarHeight ?? this.toolbarHeight,
      articleContentMaxWidth: articleContentMaxWidth ?? this.articleContentMaxWidth,
    );
  }

  @override
  AppLayouts lerp(
    ThemeExtension<AppLayouts>? other,
    double t,
  ) {
    if (other is! AppLayouts) {
      return this;
    }

    return AppLayouts(
      loadingSize: ui.lerpDouble(
            loadingSize,
            other.loadingSize,
            t,
          ) ??
          loadingSize,

      authIconSize: ui.lerpDouble(
            authIconSize,
            other.authIconSize,
            t,
          ) ??
          authIconSize,

      authContentMaxWidth: ui.lerpDouble(
            authContentMaxWidth,
            other.authContentMaxWidth,
            t,
          ) ??
          authContentMaxWidth,

      authFieldHeight: ui.lerpDouble(
            authFieldHeight,
            other.authFieldHeight,
            t,
          ) ??
          authFieldHeight,

      loginButtonSize: ui.lerpDouble(
            loginButtonSize,
            other.loginButtonSize,
            t,
          ) ??
          loginButtonSize,

      authorIconSize: ui.lerpDouble(
            authorIconSize,
            other.authorIconSize,
            t,
          ) ??
          authorIconSize,

      tagHeight: ui.lerpDouble(
            tagHeight,
            other.tagHeight,
            t,
          ) ??
          tagHeight,

      articleMaxHeigth: ui.lerpDouble(
            articleMaxHeigth,
            other.articleMaxHeigth,
            t,
          ) ??
          articleMaxHeigth,

      writeArticleButtonSize: ui.lerpDouble(
            writeArticleButtonSize,
            other.writeArticleButtonSize,
            t,
          ) ??
          writeArticleButtonSize,
      
      doneButton: ui.lerpDouble(doneButton, other.doneButton, t) ?? doneButton,
      toolbarHeight: ui.lerpDouble(toolbarHeight, other.toolbarHeight, t) ?? toolbarHeight,
      articleContentMaxWidth: ui.lerpDouble(articleContentMaxWidth, other.articleContentMaxWidth, t) ?? articleContentMaxWidth,
    );
  }
}

extension AppLayoutsBuildContext on BuildContext {
  AppLayouts get layouts =>
      Theme.of(this).extension<AppLayouts>()!;
}