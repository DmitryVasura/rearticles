sealed class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

final class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException()
      : super('Неверный email или пароль');
}

final class EmailAlreadyExistsException extends AuthException {
  const EmailAlreadyExistsException()
      : super('Этот email уже зарегистрирован');
}

final class UsernameAlreadyExistsException extends AuthException {
  const UsernameAlreadyExistsException()
      : super('Это имя пользователя уже занято');
}

final class InvalidRequestException extends AuthException {
  const InvalidRequestException()
      : super('Некорректные данные');
}

final class ServerException extends AuthException {
  const ServerException()
      : super('Ошибка сервера. Попробуйте ещё раз');
}

final class NetworkException extends AuthException {
  const NetworkException()
      : super('Не удалось подключиться к серверу');
}

final class UnknownAuthException extends AuthException {
  const UnknownAuthException()
      : super('Произошла неизвестная ошибка');
}