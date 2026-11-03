// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

  @override
  String get feedback => 'Feedback';

  @override
  String get hapticFeedback => 'Haptic feedback';

  @override
  String get hapticFeedbackSubtitle => 'Vibration on likes and long press';

  @override
  String get data => 'Data';

  @override
  String get deleteAllDrafts => 'Delete all drafts';

  @override
  String get deleteAllDraftsSubtitle => 'Removes drafts stored on this device';

  @override
  String get deleteAllDraftsTitle => 'Delete all drafts?';

  @override
  String get deleteAllDraftsMessage =>
      'Drafts stored on this device will be deleted permanently.';

  @override
  String get draftsDeleted => 'Drafts deleted';

  @override
  String get about => 'About';

  @override
  String aboutApp(String appName) {
    return 'About $appName';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get retry => 'Retry';

  @override
  String get undo => 'Undo';

  @override
  String get error => 'Error';

  @override
  String get report => 'Report';

  @override
  String get dontLike => 'Don\'t like';

  @override
  String get reportWhy => 'Why are you reporting this article?';

  @override
  String get hideFailed => 'Could not hide the article';

  @override
  String get reportFailed => 'Could not send the report';

  @override
  String get fewerLikeThis => 'We\'ll show fewer articles like this';

  @override
  String get reportThanks => 'Thanks, we\'ll review this article';

  @override
  String get reasonSpam => 'Spam';

  @override
  String get reasonInappropriate => 'Inappropriate content';

  @override
  String get reasonMisinformation => 'Misinformation';

  @override
  String get reasonPlagiarism => 'Plagiarism';

  @override
  String get reasonOther => 'Other';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyNormal => 'Normal';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyAdvanced => 'Advanced';

  @override
  String get createAnAccount => 'Create an account';

  @override
  String get createAccount => 'Create account';

  @override
  String get email => 'Email';

  @override
  String get loginName => 'Login';

  @override
  String get logIn => 'Login';

  @override
  String get register => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get noAccountYet => 'Don\'t have an account?';

  @override
  String get loading => 'Loading...';

  @override
  String get welcomeMessage =>
      'Welcome to Re:Articles. Please, login or register to continue';

  @override
  String get unknownAuthor => 'Unknown Author';

  @override
  String get writeArticle => 'Write Article';

  @override
  String get editArticle => 'Edit Article';

  @override
  String get articleTitleHint => 'Article title';

  @override
  String get forYou => 'For you';

  @override
  String get latest => 'Latest';

  @override
  String get chooseDraftOrNew => 'Choose a draft or create a new article';

  @override
  String failedLoadDrafts(String message) {
    return 'Failed to load drafts:\n$message';
  }

  @override
  String get noDraftsYet =>
      'No drafts yet.\nCreate a new article to get started.';

  @override
  String get newArticle => 'New Article';

  @override
  String maxTagsError(int count) {
    return 'You can select up to $count tags';
  }

  @override
  String minTagsError(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Select at least $count tags',
      one: 'Select at least 1 tag',
    );
    return '$_temp0';
  }

  @override
  String get needTitle => 'Your article needs a title';

  @override
  String get articleUpdated => 'Article updated';

  @override
  String get articlePublished => 'Article published';

  @override
  String get editArticleTitle => 'Edit article';

  @override
  String get publishArticleTitle => 'Publish article';

  @override
  String get publishIntro =>
      'Add a few details to help readers discover your article.';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get difficultySubtitle => 'How challenging is your article?';

  @override
  String get tags => 'Tags';

  @override
  String get tagsSubtitle => 'Choose topics that describe your article.';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get publishArticle => 'Publish Article';

  @override
  String get searchTags => 'Search tags...';

  @override
  String get selected => 'Selected';

  @override
  String get allTags => 'All tags';

  @override
  String get failedLoadTags => 'Failed to load tags';

  @override
  String get noTagsFound => 'No tags found';

  @override
  String get untitledArticle => 'Untitled article';

  @override
  String get noContentYet => 'No content yet';

  @override
  String get quickPublish => 'Quick publish';

  @override
  String get editedJustNow => 'Edited just now';

  @override
  String editedMinutesAgo(int count) {
    return 'Edited $count min ago';
  }

  @override
  String editedHoursAgo(int count) {
    return 'Edited $count h ago';
  }

  @override
  String get editedYesterday => 'Edited yesterday';

  @override
  String editedDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Edited $count days ago',
      one: 'Edited 1 day ago',
    );
    return '$_temp0';
  }

  @override
  String editedOn(String date) {
    return 'Edited $date';
  }

  @override
  String get noArticlesYet => 'No articles yet';

  @override
  String get deleteArticleTitle => 'Delete article?';

  @override
  String get deleteArticleMessage =>
      'The article will be removed for everyone. This cannot be undone.';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get articles => 'Articles';

  @override
  String get likesReceived => 'Likes received';

  @override
  String get username => 'Username';

  @override
  String get author => 'Author';

  @override
  String get account => 'Account';

  @override
  String get myArticles => 'My articles';

  @override
  String get likedArticles => 'Liked articles';

  @override
  String get logOut => 'Log Out';

  @override
  String get noPublishedYet => 'You have not published any articles yet';

  @override
  String get likedWillAppear => 'Articles you like will appear here';
}
