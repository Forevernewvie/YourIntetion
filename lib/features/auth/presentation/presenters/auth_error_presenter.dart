import '../../../../core/error/app_failure.dart';

/// Purpose: Convert auth-domain failures into deterministic UI-facing messages.
final class AuthErrorPresenter {
  AuthErrorPresenter._();

  /// Purpose: Return backend failure text when available or fall back to a safe default.
  static String present(Object? error, {required String fallbackMessage}) {
    if (error is AppFailure) {
      return error.message;
    }
    return fallbackMessage;
  }
}
