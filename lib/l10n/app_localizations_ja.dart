// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get settings => '設定';

  @override
  String get appearance => '外観';

  @override
  String get theme => 'テーマ';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get language => '言語';

  @override
  String get languageSystem => 'システムの設定';

  @override
  String get feedback => 'フィードバック';

  @override
  String get hapticFeedback => '触覚フィードバック';

  @override
  String get hapticFeedbackSubtitle => 'いいねや長押しで振動します';

  @override
  String get data => 'データ';

  @override
  String get deleteAllDrafts => 'すべての下書きを削除';

  @override
  String get deleteAllDraftsSubtitle => 'この端末に保存された下書きを削除します';

  @override
  String get deleteAllDraftsTitle => 'すべての下書きを削除しますか?';

  @override
  String get deleteAllDraftsMessage => 'この端末の下書きは完全に削除されます。';

  @override
  String get draftsDeleted => '下書きを削除しました';

  @override
  String get about => 'アプリについて';

  @override
  String aboutApp(String appName) {
    return '$appNameについて';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get retry => '再試行';

  @override
  String get undo => '元に戻す';

  @override
  String get error => 'エラー';

  @override
  String get report => '報告';

  @override
  String get dontLike => '興味なし';

  @override
  String get reportWhy => 'この記事を報告する理由は?';

  @override
  String get hideFailed => '記事を非表示にできませんでした';

  @override
  String get reportFailed => '報告を送信できませんでした';

  @override
  String get fewerLikeThis => 'このような記事の表示を減らします';

  @override
  String get reportThanks => 'ありがとうございます。この記事を確認します';

  @override
  String get reasonSpam => 'スパム';

  @override
  String get reasonInappropriate => '不適切なコンテンツ';

  @override
  String get reasonMisinformation => '誤情報';

  @override
  String get reasonPlagiarism => '盗用';

  @override
  String get reasonOther => 'その他';

  @override
  String get difficultyEasy => 'やさしい';

  @override
  String get difficultyNormal => 'ふつう';

  @override
  String get difficultyMedium => '中級';

  @override
  String get difficultyHard => '難しい';

  @override
  String get difficultyAdvanced => '上級';

  @override
  String get createAnAccount => 'アカウントを作成';

  @override
  String get createAccount => 'アカウントを作成';

  @override
  String get email => 'メールアドレス';

  @override
  String get loginName => 'ログイン名';

  @override
  String get logIn => 'ログイン';

  @override
  String get register => '新規登録';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちですか?';

  @override
  String get noAccountYet => 'アカウントをお持ちでないですか?';

  @override
  String get loading => '読み込み中...';

  @override
  String get welcomeMessage => 'Re:Articlesへようこそ。続けるにはログインまたは登録してください。';

  @override
  String get unknownAuthor => '不明な著者';

  @override
  String get writeArticle => '記事を書く';

  @override
  String get editArticle => '記事を編集';

  @override
  String get articleTitleHint => '記事のタイトル';

  @override
  String get forYou => 'おすすめ';

  @override
  String get latest => '新着';

  @override
  String get chooseDraftOrNew => '下書きを選ぶか、新しい記事を作成しましょう';

  @override
  String failedLoadDrafts(String message) {
    return '下書きを読み込めませんでした:\n$message';
  }

  @override
  String get noDraftsYet => '下書きはまだありません。\n新しい記事を作成して始めましょう。';

  @override
  String get newArticle => '新しい記事';

  @override
  String maxTagsError(int count) {
    return 'タグは最大$count個まで選択できます';
  }

  @override
  String minTagsError(int count) {
    return 'タグを$count個以上選択してください';
  }

  @override
  String get needTitle => '記事にはタイトルが必要です';

  @override
  String get articleUpdated => '記事を更新しました';

  @override
  String get articlePublished => '記事を公開しました';

  @override
  String get editArticleTitle => '記事を編集';

  @override
  String get publishArticleTitle => '記事を公開';

  @override
  String get publishIntro => '読者が記事を見つけやすいように、いくつか詳細を追加しましょう。';

  @override
  String get difficulty => '難易度';

  @override
  String get difficultySubtitle => '記事の難しさはどのくらいですか?';

  @override
  String get tags => 'タグ';

  @override
  String get tagsSubtitle => '記事の内容を表すトピックを選んでください。';

  @override
  String get saveChanges => '変更を保存';

  @override
  String get publishArticle => '記事を公開';

  @override
  String get searchTags => 'タグを検索...';

  @override
  String get selected => '選択中';

  @override
  String get allTags => 'すべてのタグ';

  @override
  String get failedLoadTags => 'タグを読み込めませんでした';

  @override
  String get noTagsFound => 'タグが見つかりません';

  @override
  String get untitledArticle => '無題の記事';

  @override
  String get noContentYet => 'まだ内容がありません';

  @override
  String get quickPublish => 'すぐに公開';

  @override
  String get editedJustNow => 'たった今編集';

  @override
  String editedMinutesAgo(int count) {
    return '$count分前に編集';
  }

  @override
  String editedHoursAgo(int count) {
    return '$count時間前に編集';
  }

  @override
  String get editedYesterday => '昨日編集';

  @override
  String editedDaysAgo(int count) {
    return '$count日前に編集';
  }

  @override
  String editedOn(String date) {
    return '$dateに編集';
  }

  @override
  String get noArticlesYet => '記事はまだありません';

  @override
  String get deleteArticleTitle => '記事を削除しますか?';

  @override
  String get deleteArticleMessage => '記事はすべてのユーザーから削除されます。この操作は取り消せません。';

  @override
  String get home => 'ホーム';

  @override
  String get profile => 'プロフィール';

  @override
  String get articles => '記事';

  @override
  String get likesReceived => 'もらったいいね';

  @override
  String get username => 'ユーザー名';

  @override
  String get author => '著者';

  @override
  String get account => 'アカウント';

  @override
  String get myArticles => '自分の記事';

  @override
  String get likedArticles => 'いいねした記事';

  @override
  String get logOut => 'ログアウト';

  @override
  String get noPublishedYet => 'まだ記事を公開していません';

  @override
  String get likedWillAppear => 'いいねした記事がここに表示されます';
}
