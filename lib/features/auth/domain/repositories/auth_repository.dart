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

  /// Purpose: Restore locally persisted session if available.
  Future<AuthSession?> restoreSession();

  /// Purpose: Clear persisted session and sign user out from app context.
  Future<void> signOut();
}
