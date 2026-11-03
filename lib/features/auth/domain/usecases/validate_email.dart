class ValidateEmail {
  String? call(String email) {
    final value = email.trim();

    if (value.isEmpty) {
      return 'Введите email';
    }

    final emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Введите корректный email';
    }

    return null;
  }
}