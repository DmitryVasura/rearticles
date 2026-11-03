import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AppRadiuses extends ThemeExtension<AppRadiuses> {
  final double s;
  final double m;
  final double b;
  final double xl;

  const AppRadiuses({
    required this.s,
    required this.m,
    required this.b,
    required this.xl,
  });

  factory AppRadiuses.regular() => const AppRadiuses(
    s: 8, 
    m: 15, 
    b: 30, 
    xl: 45
  );

  @override
  AppRadiuses copyWith({
    double? s,
    double? m,
    double? b,
    double? xl
  }) {
    return AppRadiuses(
      s: s ?? this.s, 
      m: m ?? this.m, 
      b: b ?? this.b, 
      xl: xl ?? this.xl
    );
  }

  @override
  AppRadiuses lerp(ThemeExtension<AppRadiuses>? other, double t) {
    if (other is! AppRadiuses) return this;
    return AppRadiuses(
      s: ui.lerpDouble(s, other.s, t) ?? s, 
      m: ui.lerpDouble(m, other.m, t) ?? m, 
      b: ui.lerpDouble(b, other.b, t) ?? b, 
      xl: ui.lerpDouble(xl, other.xl, t) ?? xl,
    );
  }
}

extension AppRadiusesBuildContext on BuildContext {
  AppRadiuses get radiuses => Theme.of(this).extension<AppRadiuses>()!;
}