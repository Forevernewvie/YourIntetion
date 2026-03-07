import '../../../../core/constants/app_constants.dart';

/// Purpose: Centralize auth form validation rules for reuse and unit testing.
final class AuthInputValidator {
  AuthInputValidator._();

  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// Purpose: Validate that a name field contains meaningful non-whitespace input.
  static String? validateName(String? value) {
    return validateRequiredText(
      value,
      emptyMessage: AppAuthMessage.nameRequired,
    );
  }

  /// Purpose: Validate email format with lightweight client-side checks.
  static String? validateEmail(String? value) {
    final input = (value ?? '').trim();
    if (input.isEmpty || !_emailPattern.hasMatch(input)) {
      return AppAuthMessage.invalidEmail;
    }
    return null;
  }

  /// Purpose: Validate password length against centralized auth policy.
  static String? validatePassword(String? value) {
    final input = value ?? '';
    if (input.length < AppAuthPolicy.minPasswordLength) {
      return AppAuthMessage.passwordTooShort;
    }
    return null;
  }

  /// Purpose: Validate password confirmation against the original password field.
  static String? validatePasswordConfirmation(
    String? value, {
    required String password,
  }) {
    if ((value ?? '') != password) {
      return AppAuthMessage.passwordConfirmationMismatch;
    }
    return null;
  }

  /// Purpose: Validate that a reset token is present before submission.
  static String? validateResetToken(String? value) {
    return validateRequiredText(
      value,
      emptyMessage: AppAuthMessage.resetTokenRequired,
    );
  }

  /// Purpose: Validate that a text field is not empty after trimming whitespace.
  static String? validateRequiredText(
    String? value, {
    required String emptyMessage,
  }) {
    if ((value ?? '').trim().isEmpty) {
      return emptyMessage;
    }
    return null;
  }
}
