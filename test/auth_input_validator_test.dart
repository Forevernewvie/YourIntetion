import 'package:flutter_test/flutter_test.dart';
import 'package:vibecodingexpert/core/constants/app_constants.dart';
import 'package:vibecodingexpert/features/auth/presentation/validation/auth_input_validator.dart';

void main() {
  group('AuthInputValidator', () {
    test('rejects blank names after trimming', () {
      final message = AuthInputValidator.validateName('   ');

      expect(message, AppAuthMessage.nameRequired);
    });

    test('accepts well-formed email addresses', () {
      final message = AuthInputValidator.validateEmail('reader@example.com');

      expect(message, isNull);
    });

    test('rejects malformed email addresses', () {
      final message = AuthInputValidator.validateEmail('reader@invalid');

      expect(message, AppAuthMessage.invalidEmail);
    });

    test('enforces minimum password length', () {
      final message = AuthInputValidator.validatePassword('short');

      expect(message, AppAuthMessage.passwordTooShort);
    });

    test('checks password confirmation against the original password', () {
      final message = AuthInputValidator.validatePasswordConfirmation(
        'different',
        password: 'password-123',
      );

      expect(message, AppAuthMessage.passwordConfirmationMismatch);
    });

    test('requires reset token presence after trimming', () {
      final message = AuthInputValidator.validateResetToken('   ');

      expect(message, AppAuthMessage.resetTokenRequired);
    });
  });
}
