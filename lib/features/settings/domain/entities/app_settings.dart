import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum UiSize { auto, compact, regular, large }

class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final UiSize uiSize;
  final bool haptics;

  /// null — следовать языку системы.
  final Locale? locale;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.uiSize = UiSize.auto,
    this.haptics = true,
    this.locale,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    UiSize? uiSize,
    bool? haptics,
    Locale? locale,
    bool resetLocale = false,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      uiSize: uiSize ?? this.uiSize,
      haptics: haptics ?? this.haptics,
      locale: resetLocale ? null : (locale ?? this.locale),
    );
  }

  @override
  List<Object?> get props => [themeMode, uiSize, haptics, locale];
}