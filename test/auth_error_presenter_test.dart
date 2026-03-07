import 'package:flutter_test/flutter_test.dart';
import 'package:vibecodingexpert/core/error/app_failure.dart';
import 'package:vibecodingexpert/features/auth/presentation/presenters/auth_error_presenter.dart';

void main() {
  group('AuthErrorPresenter', () {
    test('returns app failure message when available', () {
      const failure = AppFailure(
        code: AppErrorCode.apiBadResponse,
        message: 'backend-auth-error',
      );

      final message = AuthErrorPresenter.present(
        failure,
        fallbackMessage: 'fallback-auth-error',
      );

      expect(message, 'backend-auth-error');
    });

    test('returns fallback message for unknown error types', () {
      final message = AuthErrorPresenter.present(
        Exception('unexpected'),
        fallbackMessage: 'fallback-auth-error',
      );

      expect(message, 'fallback-auth-error');
    });
  });
}
