// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settings => 'Настройки';

  @override
  String get appearance => 'Оформление';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Как в системе';

  @override
  String get feedback => 'Отклик';

  @override
  String get hapticFeedback => 'Вибрация';

  @override
  String get hapticFeedbackSubtitle => 'Вибрация при лайках и долгом нажатии';

  @override
  String get data => 'Данные';

  @override
  String get deleteAllDrafts => 'Удалить все черновики';

  @override
  String get deleteAllDraftsSubtitle =>
      'Удаляет черновики, хранящиеся на устройстве';

  @override
  String get deleteAllDraftsTitle => 'Удалить все черновики?';

  @override
  String get deleteAllDraftsMessage =>
      'Черновики на этом устройстве будут удалены без возможности восстановления.';

  @override
  String get draftsDeleted => 'Черновики удалены';

  @override
  String get about => 'О приложении';

  @override
  String aboutApp(String appName) {
    return 'О приложении $appName';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Изменить';

  @override
  String get retry => 'Повторить';

  @override
  String get undo => 'Отменить';

  @override
  String get error => 'Ошибка';

  @override
  String get report => 'Пожаловаться';

  @override
  String get dontLike => 'Не нравится';

  @override
  String get reportWhy => 'Почему вы жалуетесь на эту статью?';

  @override
  String get hideFailed => 'Не удалось скрыть статью';

  @override
  String get reportFailed => 'Не удалось отправить жалобу';

  @override
  String get fewerLikeThis => 'Мы будем показывать меньше подобных статей';

  @override
  String get reportThanks => 'Спасибо, мы проверим эту статью';

  @override
  String get reasonSpam => 'Спам';

  @override
  String get reasonInappropriate => 'Неприемлемый контент';

  @override
  String get reasonMisinformation => 'Недостоверная информация';

  @override
  String get reasonPlagiarism => 'Плагиат';

  @override
  String get reasonOther => 'Другое';

  @override
  String get difficultyEasy => 'Лёгкий';

  @override
  String get difficultyNormal => 'Обычный';

  @override
  String get difficultyMedium => 'Средний';

  @override
  String get difficultyHard => 'Сложный';

  @override
  String get difficultyAdvanced => 'Продвинутый';

  @override
  String get createAnAccount => 'Создайте аккаунт';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get email => 'Email';

  @override
  String get loginName => 'Логин';

  @override
  String get logIn => 'Войти';

  @override
  String get register => 'Регистрация';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get noAccountYet => 'Нет аккаунта?';

  @override
  String get loading => 'Загрузка...';

  @override
  String get welcomeMessage =>
      'Добро пожаловать в Re:Articles. Войдите или зарегистрируйтесь, чтобы продолжить';

  @override
  String get unknownAuthor => 'Неизвестный автор';

  @override
  String get writeArticle => 'Написать статью';

  @override
  String get editArticle => 'Редактирование статьи';

  @override
  String get articleTitleHint => 'Заголовок статьи';

  @override
  String get forYou => 'Для вас';

  @override
  String get latest => 'Новое';

  @override
  String get chooseDraftOrNew => 'Выберите черновик или создайте новую статью';

  @override
  String failedLoadDrafts(String message) {
    return 'Не удалось загрузить черновики:\n$message';
  }

  @override
  String get noDraftsYet =>
      'Черновиков пока нет.\nСоздайте новую статью, чтобы начать.';

  @override
  String get newArticle => 'Новая статья';

  @override
  String maxTagsError(int count) {
    return 'Максимум тегов: $count';
  }

  @override
  String minTagsError(int count) {
    return 'Выберите минимум тегов: $count';
  }

  @override
  String get needTitle => 'Добавьте заголовок статьи';

  @override
  String get articleUpdated => 'Статья обновлена';

  @override
  String get articlePublished => 'Статья опубликована';

  @override
  String get editArticleTitle => 'Редактирование статьи';

  @override
  String get publishArticleTitle => 'Публикация статьи';

  @override
  String get publishIntro =>
      'Добавьте пару деталей, чтобы читателям было проще найти вашу статью.';

  @override
  String get difficulty => 'Сложность';

  @override
  String get difficultySubtitle => 'Насколько сложна ваша статья?';

  @override
  String get tags => 'Теги';

  @override
  String get tagsSubtitle => 'Выберите темы, которые описывают вашу статью.';

  @override
  String get saveChanges => 'Сохранить изменения';

  @override
  String get publishArticle => 'Опубликовать статью';

  @override
  String get searchTags => 'Поиск тегов...';

  @override
  String get selected => 'Выбрано';

  @override
  String get allTags => 'Все теги';

  @override
  String get failedLoadTags => 'Не удалось загрузить теги';

  @override
  String get noTagsFound => 'Теги не найдены';

  @override
  String get untitledArticle => 'Статья без названия';

  @override
  String get noContentYet => 'Пока нет содержимого';

  @override
  String get quickPublish => 'Быстрая публикация';

  @override
  String get editedJustNow => 'Изменено только что';

  @override
  String editedMinutesAgo(int count) {
    return 'Изменено $count мин назад';
  }

  @override
  String editedHoursAgo(int count) {
    return 'Изменено $count ч назад';
  }

  @override
  String get editedYesterday => 'Изменено вчера';

  @override
  String editedDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изменено $count дня назад',
      many: 'Изменено $count дней назад',
      few: 'Изменено $count дня назад',
      one: 'Изменено $count день назад',
    );
    return '$_temp0';
  }

  @override
  String editedOn(String date) {
    return 'Изменено $date';
  }

  @override
  String get noArticlesYet => 'Статей пока нет';

  @override
  String get deleteArticleTitle => 'Удалить статью?';

  @override
  String get deleteArticleMessage =>
      'Статья будет удалена для всех. Это действие нельзя отменить.';

  @override
  String get home => 'Главная';

  @override
  String get profile => 'Профиль';

  @override
  String get articles => 'Статьи';

  @override
  String get likesReceived => 'Получено лайков';

  @override
  String get username => 'Имя пользователя';

  @override
  String get author => 'Автор';

  @override
  String get account => 'Аккаунт';

  @override
  String get myArticles => 'Мои статьи';

  @override
  String get likedArticles => 'Понравившиеся статьи';

  @override
  String get logOut => 'Выйти';

  @override
  String get noPublishedYet => 'Вы ещё не опубликовали ни одной статьи';

  @override
  String get likedWillAppear => 'Здесь появятся статьи, которые вам понравятся';
}
