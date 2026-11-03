import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_articles/features/settings/data/settings_storage.dart';
import 'package:re_articles/features/settings/domain/entities/app_settings.dart';

class SettingsCubit extends Cubit<AppSettings> {
  final SettingsStorage storage;

  SettingsCubit(this.storage) : super(storage.load());

  void setThemeMode(ThemeMode mode) =>
      _update(state.copyWith(themeMode: mode));

  void setUiSize(UiSize size) => _update(state.copyWith(uiSize: size));

  void setHaptics(bool enabled) => _update(state.copyWith(haptics: enabled));

  /// null — следовать языку системы.
  void setLocale(Locale? locale) => _update(
    locale == null
        ? state.copyWith(resetLocale: true)
        : state.copyWith(locale: locale),
  );

  void _update(AppSettings settings) {
    emit(settings);
    storage.save(settings);
  }
}