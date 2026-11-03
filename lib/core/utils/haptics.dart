import 'package:flutter/services.dart';
import 'package:re_articles/core/di/injection.dart';

// Пауза между двумя касаниями в «успехе».
const _doubleTapPause = Duration(milliseconds: 90);

abstract final class Haptics {
  static bool get _enabled => Injection.settingsCubit.state.haptics;

  static void light() {
    if (_enabled) HapticFeedback.lightImpact();
  }

  static void selection() {
    if (_enabled) HapticFeedback.selectionClick();
  }

  static void medium() {
    if (_enabled) HapticFeedback.mediumImpact();
  }

  static Future<void> success() async {
    if (!_enabled) return;

    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(_doubleTapPause);

    if (_enabled) HapticFeedback.lightImpact();
  }

  static void error() {
    if (_enabled) HapticFeedback.heavyImpact();
  }
}