import 'package:re_articles/l10n/l10n.dart';

enum ReportReason {
  spam,
  inappropriate,
  misinformation,
  plagiarism,
  other;

  String localized(AppLocalizations l10n) => switch (this) {
    spam => l10n.reasonSpam,
    inappropriate => l10n.reasonInappropriate,
    misinformation => l10n.reasonMisinformation,
    plagiarism => l10n.reasonPlagiarism,
    other => l10n.reasonOther,
  };
}
