import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibecodingexpert/core/session/session_providers.dart';
import 'package:vibecodingexpert/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vibecodingexpert/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vibecodingexpert/features/auth/domain/entities/auth_session.dart';
import 'package:vibecodingexpert/features/auth/presentation/providers/auth_providers.dart';

void main() {
  group('AuthController', () {
    test(
      'restores bootstrap session and syncs app session providers',
      () async {
        final repository = _FakeAuthRepositorySessionDataSource();
        final container = ProviderContainer(
          overrides: [
            authLocalDataSourceProvider.overrideWithValue(repository),
            authRemoteDataSourceProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        final session = await container.read(authControllerProvider.future);

        expect(session?.email, 'user@example.com');
        expect(container.read(accessTokenProvider), 'token-123');
        expect(container.read(currentUserVerifiedProvider), isTrue);
      },
    );

    test('signIn updates controller state and session providers', () async {
      final repository = _FakeAuthRepositorySessionDataSource();
      final container = ProviderContainer(
        overrides: [
          authLocalDataSourceProvider.overrideWithValue(repository),
          authRemoteDataSourceProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authControllerProvider.future);

      await container
          .read(authControllerProvider.notifier)
          .signIn(email: 'user@example.com', password: 'password-123');

      expect(
        container.read(authControllerProvider).valueOrNull?.userId,
        'user-1',
      );
      expect(container.read(accessTokenProvider), 'token-123');
      expect(repository.lastSignInEmail, 'user@example.com');
    });

    test('signOut clears synced session providers', () async {
      final repository = _FakeAuthRepositorySessionDataSource();
      final container = ProviderContainer(
        overrides: [
          authLocalDataSourceProvider.overrideWithValue(repository),
          authRemoteDataSourceProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authControllerProvider.future);
      await container
          .read(authControllerProvider.notifier)
          .signIn(email: 'user@example.com', password: 'password-123');

      await container.read(authControllerProvider.notifier).signOut();

      expect(container.read(authControllerProvider).valueOrNull, isNull);
      expect(container.read(accessTokenProvider), isNull);
      expect(container.read(currentUserVerifiedProvider), isFalse);
    });
  });
}

class _FakeAuthRepositorySessionDataSource
    implements AuthLocalDataSource, AuthRemoteDataSource {
  String? lastSignInEmail;
  AuthSession? _storedSession = _session;

  @override
  Future<void> clearSession() async {
    _storedSession = null;
  }

  @override
  Future<void> confirmEmailVerification({required String token}) async {}

  @override
  Future<void> confirmPasswordReset({
    required String token,
    required String password,
  }) async {}

  @override
  Future<AuthSession?> readSession() async {
    return _storedSession;
  }

  @override
  Future<AuthSession> refreshSession() async {
    return _session;
  }

  @override
  Future<void> requestEmailVerification({required String email}) async {}

  @override
  Future<void> requestPasswordReset({required String email}) async {}

  @override
  Future<void> saveSession(AuthSession session) async {
    _storedSession = session;
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    lastSignInEmail = email;
    _storedSession = _session;
    return _session;
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {}

  static const _session = AuthSession(
    userId: 'user-1',
    email: 'user@example.com',
    token: 'token-123',
    isVerified: true,
  );
}
