import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibecodingexpert/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:vibecodingexpert/features/auth/domain/entities/auth_session.dart';

void main() {
  group('AuthLocalDataSourceImpl', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{});
    });

    test('persists and restores verified flag with session fields', () async {
      const dataSource = AuthLocalDataSourceImpl();
      const session = AuthSession(
        token: 'token_123',
        userId: 'user_1',
        email: 'user@example.com',
        isVerified: true,
        name: 'Tester',
      );

      await dataSource.saveSession(session);
      final restored = await dataSource.readSession();

      expect(restored, isNotNull);
      expect(restored!.token, equals(session.token));
      expect(restored.userId, equals(session.userId));
      expect(restored.email, equals(session.email));
      expect(restored.isVerified, isTrue);
      expect(restored.name, equals(session.name));
    });
  });
}
