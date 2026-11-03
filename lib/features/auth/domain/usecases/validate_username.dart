class ValidateUsername {
  String? call(String username) {
    final value = username.trim();

    if (value.isEmpty) {
      return 'Введите имя пользователя';
    }

    if (value.length < 3) {
      return 'Имя пользователя должно содержать минимум 3 символа';
    }

    if (value.length > 20) {
      return 'Имя пользователя должно содержать максимум 20 символов';
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');

    if (!usernameRegex.hasMatch(value)) {
      return 'Используйте только латинские буквы, цифры и _';
    }

    return null;
  }
}