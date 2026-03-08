import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

/// Purpose: Restore previously persisted auth session during app bootstrap.
final class RestoreSessionUseCase {
  /// Purpose: Construct restore-session use case with auth repository dependency.
  const RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  /// Purpose: Load the locally persisted session snapshot when available.
  Future<AuthSession?> call() {
    return _repository.restoreSession();
  }
}

/// Purpose: Execute interactive sign-in flow through the auth repository contract.
final class SignInUseCase {
  /// Purpose: Construct sign-in use case with auth repository dependency.
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  /// Purpose: Authenticate a user and return the resulting session.
  Future<AuthSession> call({required String email, required String password}) {
    return _repository.signIn(email: email, password: password);
  }
}

/// Purpose: Execute account registration flow through the auth repository contract.
final class SignUpUseCase {
  /// Purpose: Construct sign-up use case with auth repository dependency.
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  /// Purpose: Register a new account and return the authenticated session.
  Future<AuthSession> call({
    required String email,
    required String password,
    required String name,
  }) {
    return _repository.signUp(email: email, password: password, name: name);
  }
}

/// Purpose: Execute sign-out flow through the auth repository contract.
final class SignOutUseCase {
  /// Purpose: Construct sign-out use case with auth repository dependency.
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  /// Purpose: Clear persisted session state for the current account.
  Future<void> call() {
    return _repository.signOut();
  }
}

/// Purpose: Refresh the current authenticated session from the backend.
final class RefreshSessionUseCase {
  /// Purpose: Construct refresh-session use case with auth repository dependency.
  const RefreshSessionUseCase(this._repository);

  final AuthRepository _repository;

  /// Purpose: Return an updated session with the latest backend flags and token.
  Future<AuthSession> call() {
    return _repository.refreshSession();
  }
}

/// Purpose: Trigger verification email delivery for the active account.
final class ResendVerificationUseCase {
  /// Purpose: Construct resend-verification use case with auth repository dependency.
  const ResendVerificationUseCase(this._repository);

  final AuthRepository _repository;

  /// Purpose: Request another verification email for the provided account email.
  Future<void> call({required String email}) {
    return _repository.resendVerification(email: email);
  }
}

/// Purpose: Confirm email verification by submitting the received token.
final class ConfirmEmailVerificationUseCase {
  /// Purpose: Construct confirm-verification use case with auth repository dependency.
  const ConfirmEmailVerificationUseCase(this._repository);

  final AuthRepository _repository;

  /// Purpose: Confirm the verification token against the backend.
  Future<void> call({required String token}) {
    return _repository.confirmEmailVerification(token: token);
  }
}

/// Purpose: Trigger password-reset email delivery with anti-enumeration semantics.
final class RequestPasswordResetUseCase {
  /// Purpose: Construct password-reset request use case with auth repository dependency.
  const RequestPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  /// Purpose: Request password reset instructions for the provided email.
  Future<void> call({required String email}) {
    return _repository.requestPasswordReset(email: email);
  }
}

/// Purpose: Confirm password reset using a token and replacement password.
final class ConfirmPasswordResetUseCase {
  /// Purpose: Construct password-reset confirmation use case with auth repository dependency.
  const ConfirmPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  /// Purpose: Submit the reset token and new password to finalize recovery.
  Future<void> call({required String token, required String password}) {
    return _repository.confirmPasswordReset(token: token, password: password);
  }
}
