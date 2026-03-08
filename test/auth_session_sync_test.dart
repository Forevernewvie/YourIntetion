import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibecodingexpert/core/session/session_providers.dart';
import 'package:vibecodingexpert/features/auth/domain/entities/auth_session.dart';
import 'package:vibecodingexpert/features/auth/presentation/providers/auth_session_sync.dart';

void main() {
  group('AuthSessionSync', () {
    test('syncs authenticated session into global providers', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final synchronizer = container.read(authSessionSyncProvider);
      final session = AuthSession(
        userId: 'user-1',
        email: 'user@example.com',
        token: 'token-123',
        isVerified: true,
      );

      synchronizer.sync(session);

      expect(container.read(accessTokenProvider), 'token-123');
      expect(container.read(currentUserIdProvider), 'user-1');
      expect(container.read(currentUserEmailProvider), 'user@example.com');
      expect(container.read(currentUserVerifiedProvider), isTrue);
    });

    test('clears global providers when session is null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final synchronizer = container.read(authSessionSyncProvider);

      synchronizer.sync(null);

      expect(container.read(accessTokenProvider), isNull);
      expect(container.read(currentUserIdProvider), isNull);
      expect(container.read(currentUserEmailProvider), isNull);
      expect(container.read(currentUserVerifiedProvider), isFalse);
    });
  });
}
