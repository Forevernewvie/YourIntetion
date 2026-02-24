import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/auth_session.dart';

/// Purpose: Define local persistence contract for authenticated session.
abstract interface class AuthLocalDataSource {
  /// Purpose: Persist authenticated session values for app relaunch recovery.
  Future<void> saveSession(AuthSession session);

  /// Purpose: Load persisted authenticated session, or null when missing.
  Future<AuthSession?> readSession();

  /// Purpose: Remove persisted authenticated session values.
  Future<void> clearSession();
}

/// Purpose: Implement local session persistence using SharedPreferences.
final class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  /// Purpose: Construct local datasource with lazily created shared preferences.
  const AuthLocalDataSourceImpl();

  static const _tokenKey = 'auth.token';
  static const _userIdKey = 'auth.userId';
  static const _emailKey = 'auth.email';
  static const _nameKey = 'auth.name';

  /// Purpose: Persist authenticated session values.
  @override
  Future<void> saveSession(AuthSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, session.token);
    await prefs.setString(_userIdKey, session.userId);
    await prefs.setString(_emailKey, session.email);

    if (session.name == null || session.name!.isEmpty) {
      await prefs.remove(_nameKey);
      return;
    }

    await prefs.setString(_nameKey, session.name!);
  }

  /// Purpose: Read authenticated session from local persistence.
  @override
  Future<AuthSession?> readSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userId = prefs.getString(_userIdKey);
    final email = prefs.getString(_emailKey);

    if (token == null || token.isEmpty) {
      return null;
    }
    if (userId == null || userId.isEmpty) {
      return null;
    }
    if (email == null || email.isEmpty) {
      return null;
    }

    return AuthSession(
      token: token,
      userId: userId,
      email: email,
      name: prefs.getString(_nameKey),
    );
  }

  /// Purpose: Clear persisted authenticated session values.
  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_nameKey);
  }
}
