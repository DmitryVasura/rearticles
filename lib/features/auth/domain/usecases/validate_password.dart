class ValidatePassword {
  String? call(String password) {
    if (password.isEmpty) {
      return 'Введите пароль';
    }

    if (password.length < 8) {
      return 'Пароль должен содержать минимум 8 символов';
    }

    return null;
  }
}