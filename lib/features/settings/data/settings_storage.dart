import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:re_articles/features/settings/domain/entities/app_settings.dart';

class SettingsStorage {
  final Box box;

  const SettingsStorage(this.box);

  static const _themeKey = 'themeMode';
  static const _uiSizeKey = 'uiSize';
  static const _hapticsKey = 'haptics';
  static const _localeKey = 'locale';

  AppSettings load() {
    return AppSettings(
      themeMode:
          ThemeMode.values.asNameMap()[box.get(_themeKey)] ?? ThemeMode.system,
      uiSize: UiSize.values.asNameMap()[box.get(_uiSizeKey)] ?? UiSize.auto,
      haptics: box.get(_hapticsKey, defaultValue: true) as bool,
      locale: _readLocale(),
    );
  }

  Locale? _readLocale() {
    final code = box.get(_localeKey);

    return code is String && code.isNotEmpty ? Locale(code) : null;
  }

  Future<void> save(AppSettings settings) {
    return box.putAll({
      _themeKey: settings.themeMode.name,
      _uiSizeKey: settings.uiSize.name,
      _hapticsKey: settings.haptics,
      _localeKey: settings.locale?.languageCode ?? '',
    });
  }
}