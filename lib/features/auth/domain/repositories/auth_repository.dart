import '../entities/auth_session.dart';

/// Purpose: Define authentication behavior independent from concrete data sources.
abstract interface class AuthRepository {
  /// Purpose: Authenticate existing user credentials and return session.
  Future<AuthSession> signIn({required String email, required String password});

  /// Purpose: Register new user and return authenticated session.
  Future<AuthSession> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Purpose: Trigger verification email send flow for the given account email.
  Future<void> resendVerification({required String email});

  /// Purpose: Confirm verification token to mark account as verified.
  Future<void> confirmEmailVerification({required String token});

  /// Purpose: Trigger password-reset email flow for the given account email.
  Future<void> requestPasswordReset({required String email});

  /// Purpose: Confirm password reset with token and replacement password.
  Future<void> confirmPasswordReset({
    required String token,
    required String password,
  });

  /// Purpose: Refresh the currently authenticated session from backend.
  Future<AuthSession> refreshSession();

  /// Purpose: Restore locally persisted session if available.
  Future<AuthSession?> restoreSession();

  /// Purpose: Clear persisted session and sign user out from app context.
  Future<void> signOut();
}
