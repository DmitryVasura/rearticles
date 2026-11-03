import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ru'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get hapticFeedback;

  /// No description provided for @hapticFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vibration on likes and long press'**
  String get hapticFeedbackSubtitle;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @deleteAllDrafts.
  ///
  /// In en, this message translates to:
  /// **'Delete all drafts'**
  String get deleteAllDrafts;

  /// No description provided for @deleteAllDraftsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Removes drafts stored on this device'**
  String get deleteAllDraftsSubtitle;

  /// No description provided for @deleteAllDraftsTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all drafts?'**
  String get deleteAllDraftsTitle;

  /// No description provided for @deleteAllDraftsMessage.
  ///
  /// In en, this message translates to:
  /// **'Drafts stored on this device will be deleted permanently.'**
  String get deleteAllDraftsMessage;

  /// No description provided for @draftsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Drafts deleted'**
  String get draftsDeleted;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About {appName}'**
  String aboutApp(String appName);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @dontLike.
  ///
  /// In en, this message translates to:
  /// **'Don\'t like'**
  String get dontLike;

  /// No description provided for @reportWhy.
  ///
  /// In en, this message translates to:
  /// **'Why are you reporting this article?'**
  String get reportWhy;

  /// No description provided for @hideFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not hide the article'**
  String get hideFailed;

  /// No description provided for @reportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send the report'**
  String get reportFailed;

  /// No description provided for @fewerLikeThis.
  ///
  /// In en, this message translates to:
  /// **'We\'ll show fewer articles like this'**
  String get fewerLikeThis;

  /// No description provided for @reportThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks, we\'ll review this article'**
  String get reportThanks;

  /// No description provided for @reasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam'**
  String get reasonSpam;

  /// No description provided for @reasonInappropriate.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate content'**
  String get reasonInappropriate;

  /// No description provided for @reasonMisinformation.
  ///
  /// In en, this message translates to:
  /// **'Misinformation'**
  String get reasonMisinformation;

  /// No description provided for @reasonPlagiarism.
  ///
  /// In en, this message translates to:
  /// **'Plagiarism'**
  String get reasonPlagiarism;

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reasonOther;

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get difficultyNormal;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @difficultyAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get difficultyAdvanced;

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAnAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @loginName.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginName;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get logIn;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountYet;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Re:Articles. Please, login or register to continue'**
  String get welcomeMessage;

  /// No description provided for @unknownAuthor.
  ///
  /// In en, this message translates to:
  /// **'Unknown Author'**
  String get unknownAuthor;

  /// No description provided for @writeArticle.
  ///
  /// In en, this message translates to:
  /// **'Write Article'**
  String get writeArticle;

  /// No description provided for @editArticle.
  ///
  /// In en, this message translates to:
  /// **'Edit Article'**
  String get editArticle;

  /// No description provided for @articleTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Article title'**
  String get articleTitleHint;

  /// No description provided for @forYou.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get forYou;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @chooseDraftOrNew.
  ///
  /// In en, this message translates to:
  /// **'Choose a draft or create a new article'**
  String get chooseDraftOrNew;

  /// No description provided for @failedLoadDrafts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load drafts:\n{message}'**
  String failedLoadDrafts(String message);

  /// No description provided for @noDraftsYet.
  ///
  /// In en, this message translates to:
  /// **'No drafts yet.\nCreate a new article to get started.'**
  String get noDraftsYet;

  /// No description provided for @newArticle.
  ///
  /// In en, this message translates to:
  /// **'New Article'**
  String get newArticle;

  /// No description provided for @maxTagsError.
  ///
  /// In en, this message translates to:
  /// **'You can select up to {count} tags'**
  String maxTagsError(int count);

  /// No description provided for @minTagsError.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Select at least 1 tag} other{Select at least {count} tags}}'**
  String minTagsError(int count);

  /// No description provided for @needTitle.
  ///
  /// In en, this message translates to:
  /// **'Your article needs a title'**
  String get needTitle;

  /// No description provided for @articleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Article updated'**
  String get articleUpdated;

  /// No description provided for @articlePublished.
  ///
  /// In en, this message translates to:
  /// **'Article published'**
  String get articlePublished;

  /// No description provided for @editArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit article'**
  String get editArticleTitle;

  /// No description provided for @publishArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish article'**
  String get publishArticleTitle;

  /// No description provided for @publishIntro.
  ///
  /// In en, this message translates to:
  /// **'Add a few details to help readers discover your article.'**
  String get publishIntro;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @difficultySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How challenging is your article?'**
  String get difficultySubtitle;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @tagsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose topics that describe your article.'**
  String get tagsSubtitle;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @publishArticle.
  ///
  /// In en, this message translates to:
  /// **'Publish Article'**
  String get publishArticle;

  /// No description provided for @searchTags.
  ///
  /// In en, this message translates to:
  /// **'Search tags...'**
  String get searchTags;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @allTags.
  ///
  /// In en, this message translates to:
  /// **'All tags'**
  String get allTags;

  /// No description provided for @failedLoadTags.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tags'**
  String get failedLoadTags;

  /// No description provided for @noTagsFound.
  ///
  /// In en, this message translates to:
  /// **'No tags found'**
  String get noTagsFound;

  /// No description provided for @untitledArticle.
  ///
  /// In en, this message translates to:
  /// **'Untitled article'**
  String get untitledArticle;

  /// No description provided for @noContentYet.
  ///
  /// In en, this message translates to:
  /// **'No content yet'**
  String get noContentYet;

  /// No description provided for @quickPublish.
  ///
  /// In en, this message translates to:
  /// **'Quick publish'**
  String get quickPublish;

  /// No description provided for @editedJustNow.
  ///
  /// In en, this message translates to:
  /// **'Edited just now'**
  String get editedJustNow;

  /// No description provided for @editedMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'Edited {count} min ago'**
  String editedMinutesAgo(int count);

  /// No description provided for @editedHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'Edited {count} h ago'**
  String editedHoursAgo(int count);

  /// No description provided for @editedYesterday.
  ///
  /// In en, this message translates to:
  /// **'Edited yesterday'**
  String get editedYesterday;

  /// No description provided for @editedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Edited 1 day ago} other{Edited {count} days ago}}'**
  String editedDaysAgo(int count);

  /// No description provided for @editedOn.
  ///
  /// In en, this message translates to:
  /// **'Edited {date}'**
  String editedOn(String date);

  /// No description provided for @noArticlesYet.
  ///
  /// In en, this message translates to:
  /// **'No articles yet'**
  String get noArticlesYet;

  /// No description provided for @deleteArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete article?'**
  String get deleteArticleTitle;

  /// No description provided for @deleteArticleMessage.
  ///
  /// In en, this message translates to:
  /// **'The article will be removed for everyone. This cannot be undone.'**
  String get deleteArticleMessage;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @likesReceived.
  ///
  /// In en, this message translates to:
  /// **'Likes received'**
  String get likesReceived;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @myArticles.
  ///
  /// In en, this message translates to:
  /// **'My articles'**
  String get myArticles;

  /// No description provided for @likedArticles.
  ///
  /// In en, this message translates to:
  /// **'Liked articles'**
  String get likedArticles;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @noPublishedYet.
  ///
  /// In en, this message translates to:
  /// **'You have not published any articles yet'**
  String get noPublishedYet;

  /// No description provided for @likedWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Articles you like will appear here'**
  String get likedWillAppear;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
