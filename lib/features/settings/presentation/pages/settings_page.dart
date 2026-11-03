import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:re_articles/core/di/injection.dart';
import 'package:re_articles/core/themes/app_layouts.dart';
import 'package:re_articles/core/themes/radiuses.dart';
import 'package:re_articles/core/themes/spacing.dart';
import 'package:re_articles/core/utils/haptics.dart';
import 'package:re_articles/features/settings/domain/entities/app_settings.dart';
import 'package:re_articles/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:re_articles/l10n/l10n.dart';

const _appName = 'Re:Articles';
const _appVersion = '1.0.0';

// Ширина кнопки выбора справа в строке настройки.
const _choiceButtonWidth = 140.0;

String _themeLabel(AppLocalizations l10n, ThemeMode mode) => switch (mode) {
  ThemeMode.system => l10n.themeSystem,
  ThemeMode.light => l10n.themeLight,
  ThemeMode.dark => l10n.themeDark,
};

// Названия языков показываем на самих языках, чтобы их можно было найти,
// даже если сейчас выбран незнакомый язык.
const _languages = <(String, String)>[
  ('en', 'English'),
  ('ru', 'Русский'),
  ('ja', '日本語'),
];

class SettingsPage extends StatelessWidget {
  const new({super.key});

  Future<void> _clearDrafts(BuildContext context) async {
    final l10n = context.l10n;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteAllDraftsTitle),
        content: Text(l10n.deleteAllDraftsMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.delete,
              style: TextStyle(
                color: Theme.of(dialogContext).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final repository = Injection.draftRepository;
    final drafts = await repository.getAll();

    for (final draft in drafts) {
      await repository.delete(draft.id);
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.draftsDeleted)));
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final cubit = context.read<SettingsCubit>();
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.layouts.authContentMaxWidth,
          ),
          child: BlocBuilder<SettingsCubit, AppSettings>(
            builder: (context, settings) => ListView(
              padding: EdgeInsets.all(spacing.m),
              children: [
                _Section(
                  title: l10n.appearance,
                  children: [
                    _ChoiceRow<ThemeMode>(
                      icon: Icons.dark_mode_outlined,
                      title: l10n.theme,
                      value: settings.themeMode,
                      values: ThemeMode.values,
                      labelOf: (mode) => _themeLabel(l10n, mode),
                      onChanged: cubit.setThemeMode,
                    ),
                    _LanguageRow(
                      value: settings.locale,
                      onChanged: cubit.setLocale,
                    ),
                    // _ChoiceRow<UiSize>(
                    //   icon: Icons.format_size,
                    //   title: 'Interface size',
                    //   subtitle: 'Auto adapts to the window width',
                    //   value: settings.uiSize,
                    //   values: UiSize.values,
                    //   onChanged: cubit.setUiSize,
                    // ),
                  ],
                ),
                SizedBox(height: spacing.l),
                _Section(
                  title: l10n.feedback,
                  children: [
                    _SettingRow(
                      icon: Icons.vibration,
                      title: l10n.hapticFeedback,
                      subtitle: l10n.hapticFeedbackSubtitle,
                      trailing: GlassSwitch(
                        value: settings.haptics,
                        onChanged: (value) {
                          cubit.setHaptics(value);
                          Haptics.selection();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.l),
                _Section(
                  title: l10n.data,
                  children: [
                    _SettingRow(
                      icon: Icons.delete_outline,
                      title: l10n.deleteAllDrafts,
                      subtitle: l10n.deleteAllDraftsSubtitle,
                      onTap: () => _clearDrafts(context),
                    ),
                  ],
                ),
                SizedBox(height: spacing.l),
                _Section(
                  title: l10n.about,
                  children: [
                    _SettingRow(
                      icon: Icons.info_outline,
                      title: l10n.aboutApp(_appName),
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: _appName,
                        applicationVersion: _appVersion,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const new({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.s),
          child: Text(title, style: theme.textTheme.titleSmall),
        ),
        SizedBox(height: spacing.s),
        GlassContainer(
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const Divider(height: 1),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const new({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(spacing.m),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: spacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyMedium),
                  if (subtitle != null) ...[
                    SizedBox(height: spacing.xs),
                    Text(subtitle!, style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: spacing.s),
              trailing!,
            ] else if (onTap != null)
              const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _ChoiceRow<T extends Enum> extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final T value;
  final List<T> values;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  const new({
    required this.icon,
    required this.title,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _SettingRow(
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: GlassPullDownButton(
        buttonWidth: _choiceButtonWidth,
        label: labelOf(value),
        buttonShape: LiquidRoundedRectangle(
          borderRadius: context.radiuses.m,
        ),
        items: [
          for (final option in values)
            GlassMenuItem(
              title: labelOf(option),
              trailing: option == value
                  ? Icon(Icons.check, color: colors.primary)
                  : null,
              onTap: () {
                onChanged(option);
                Haptics.selection();
              },
            ),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final Locale? value;
  final ValueChanged<Locale?> onChanged;

  const new({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).colorScheme;

    String nameOf(String code) =>
        _languages.firstWhere((language) => language.$1 == code).$2;

    Widget? check(bool selected) =>
        selected ? Icon(Icons.check, color: colors.primary) : null;

    return _SettingRow(
      icon: Icons.language,
      title: l10n.language,
      trailing: GlassPullDownButton(
        buttonWidth: _choiceButtonWidth,
        label: value == null
            ? l10n.languageSystem
            : nameOf(value!.languageCode),
        buttonShape: LiquidRoundedRectangle(
          borderRadius: context.radiuses.m,
        ),
        items: [
          GlassMenuItem(
            title: l10n.languageSystem,
            trailing: check(value == null),
            onTap: () {
              onChanged(null);
              Haptics.selection();
            },
          ),
          for (final (code, name) in _languages)
            GlassMenuItem(
              title: name,
              trailing: check(value?.languageCode == code),
              onTap: () {
                onChanged(Locale(code));
                Haptics.selection();
              },
            ),
        ],
      ),
    );
  }
}
