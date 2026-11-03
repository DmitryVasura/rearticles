import 'package:flutter/widgets.dart';
import 'package:re_articles/l10n/app_localizations.dart';

export 'package:re_articles/l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
