import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AppSpacing extends ThemeExtension<AppSpacing> {
  final double xs;
  final double s;
  final double m;
  final double l;
  final double xl;
  final double xxl;

  const AppSpacing({
    required this.xs,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
    required this.xxl,
  });

  factory AppSpacing.regular() => const AppSpacing(
    xs: 4, 
    s: 8, 
    m: 16, 
    l: 24, 
    xl: 32,
    xxl: 64,
  );

  factory AppSpacing.compact() => const AppSpacing(
    xs: 2, 
    s: 6, 
    m: 12, 
    l: 18, 
    xl: 26,
    xxl: 48,
  );

  factory AppSpacing.large() => const AppSpacing(
    xs: 8, 
    s: 16, 
    m: 32, 
    l: 42, 
    xl: 50,
    xxl: 90,
  );

  @override
  AppSpacing copyWith({
    double? xs,
    double? s,
    double? m,
    double? l,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing(
      xs: xs ?? this.xs, 
      s: s ?? this.s, 
      m: m ?? this.m, 
      l: l ?? this.l, 
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppSpacing lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) return this;
    return AppSpacing(
      xs: ui.lerpDouble(xs, other.xs, t) ?? xs, 
      s: ui.lerpDouble(s, other.s, t) ?? s, 
      m: ui.lerpDouble(m, other.m, t) ?? m, 
      l: ui.lerpDouble(l, other.l, t) ?? l, 
      xl: ui.lerpDouble(xl, other.xl, t) ?? xl,
      xxl: ui.lerpDouble(xxl, other.xxl, t) ?? xxl,
    );
  }
}

extension AppSpacingBuildContext on BuildContext {
  AppSpacing get spacing => Theme.of(this).extension<AppSpacing>()!;
}