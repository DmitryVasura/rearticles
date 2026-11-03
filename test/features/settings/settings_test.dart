import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:re_articles/features/settings/data/settings_storage.dart';
import 'package:re_articles/features/settings/domain/entities/app_settings.dart';
import 'package:re_articles/features/settings/presentation/cubit/settings_cubit.dart';

void main() {
  late Directory tempDir;
  late Box box;

  // Настоящий Hive во временной папке: проверяем именно сохранение на диск.
  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('settings_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox('settings');
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('SettingsStorage', () {
    test('пустое хранилище даёт значения по умолчанию', () {
      final settings = SettingsStorage(box).load();

      expect(settings.themeMode, ThemeMode.system);
      expect(settings.uiSize, UiSize.auto);
      expect(settings.haptics, true);
    });

    test('save и load возвращают те же значения', () async {
      final storage = SettingsStorage(box);

      await storage.save(
        const AppSettings(
          themeMode: ThemeMode.dark,
          uiSize: UiSize.compact,
          haptics: false,
        ),
      );

      final loaded = storage.load();

      expect(loaded.themeMode, ThemeMode.dark);
      expect(loaded.uiSize, UiSize.compact);
      expect(loaded.haptics, false);
    });

    test('неизвестные значения заменяются значениями по умолчанию', () async {
      await box.put('themeMode', 'neon');
      await box.put('uiSize', 'huge');

      final settings = SettingsStorage(box).load();

      expect(settings.themeMode, ThemeMode.system);
      expect(settings.uiSize, UiSize.auto);
    });
  });

  group('AppSettings', () {
    test('copyWith меняет только указанное поле', () {
      const original = AppSettings();

      final copy = original.copyWith(themeMode: ThemeMode.light);

      expect(copy.themeMode, ThemeMode.light);
      expect(copy.uiSize, original.uiSize);
      expect(copy.haptics, original.haptics);
    });

    test('одинаковые настройки равны (нужно, чтобы не было лишних перерисовок)', () {
      expect(const AppSettings(), const AppSettings());
    });
  });

  group('SettingsCubit', () {
    test('начинает с сохранённых настроек', () async {
      await SettingsStorage(box).save(
        const AppSettings(themeMode: ThemeMode.dark),
      );

      final cubit = SettingsCubit(SettingsStorage(box));

      expect(cubit.state.themeMode, ThemeMode.dark);

      await cubit.close();
    });

    blocTest<SettingsCubit, AppSettings>(
      'setThemeMode меняет тему',
      build: () => SettingsCubit(SettingsStorage(box)),
      act: (cubit) => cubit.setThemeMode(ThemeMode.dark),
      expect: () => [const AppSettings(themeMode: ThemeMode.dark)],
    );

    blocTest<SettingsCubit, AppSettings>(
      'настройки меняются независимо друг от друга',
      build: () => SettingsCubit(SettingsStorage(box)),
      act: (cubit) => cubit
        ..setThemeMode(ThemeMode.light)
        ..setUiSize(UiSize.large)
        ..setHaptics(false),
      expect: () => [
        const AppSettings(themeMode: ThemeMode.light),
        const AppSettings(themeMode: ThemeMode.light, uiSize: UiSize.large),
        const AppSettings(
          themeMode: ThemeMode.light,
          uiSize: UiSize.large,
          haptics: false,
        ),
      ],
    );

    blocTest<SettingsCubit, AppSettings>(
      'то же значение второй раз не вызывает нового состояния',
      build: () => SettingsCubit(SettingsStorage(box)),
      act: (cubit) => cubit
        ..setHaptics(false)
        ..setHaptics(false),
      expect: () => [const AppSettings(haptics: false)],
    );

    test('изменения сохраняются и переживают пересоздание cubit', () async {
      final cubit = SettingsCubit(SettingsStorage(box));

      cubit
        ..setThemeMode(ThemeMode.dark)
        ..setUiSize(UiSize.compact)
        ..setHaptics(false);

      // Сохранение в cubit идёт без ожидания, даём ему завершиться.
      await pumpEventQueue(times: 200);
      await cubit.close();

      final restored = SettingsCubit(SettingsStorage(box));

      expect(restored.state.themeMode, ThemeMode.dark);
      expect(restored.state.uiSize, UiSize.compact);
      expect(restored.state.haptics, false);

      await restored.close();
    });
  });
}
