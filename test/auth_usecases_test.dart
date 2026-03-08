import 'package:flutter_test/flutter_test.dart';
import 'package:vibecodingexpert/features/auth/application/usecases/auth_usecases.dart';
import 'package:vibecodingexpert/features/auth/domain/entities/auth_session.dart';
import 'package:vibecodingexpert/features/auth/domain/repositories/auth_repository.dart';

void main() {
  group('Auth use cases', () {
    test('sign-in use case delegates to repository', () async {
      final repository = _FakeAuthRepository();
      final useCase = SignInUseCase(repository);

      final session = await useCase.call(
        email: 'user@example.com',
        password: 'password-123',
      );

      expect(repository.lastSignInEmail, 'user@example.com');
      expect(session.userId, 'user-1');
    });

    test('restore-session use case returns repository snapshot', () async {
      final repository = _FakeAuthRepository();
      final useCase = RestoreSessionUseCase(repository);

      final session = await useCase.call();

      expect(session?.email, 'user@example.com');
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  String? lastSignInEmail;

  @override
  Future<void> confirmEmailVerification({required String token}) async {}

  @override
  Future<void> confirmPasswordReset({
    required String token,
    required String password,
  }) async {}

  @override
  Future<AuthSession> refreshSession() async {
    return _session;
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {}

  @override
  Future<void> resendVerification({required String email}) async {}

  @override
  Future<AuthSession?> restoreSession() async {
    return _session;
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    lastSignInEmail = email;
    return _session;
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    return _session;
  }

  static const _session = AuthSession(
    userId: 'user-1',
    email: 'user@example.com',
    token: 'token-123',
    isVerified: true,
  );
}
