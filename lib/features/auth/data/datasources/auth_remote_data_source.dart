import 'package:dio/dio.dart';

import '../../domain/entities/auth_session.dart';

/// Purpose: Define remote authentication API contract.
abstract interface class AuthRemoteDataSource {
  /// Purpose: Authenticate a user and return backend auth session payload.
  Future<AuthSession> signIn({required String email, required String password});

  /// Purpose: Refresh authenticated session to retrieve latest user flags.
  Future<AuthSession> refreshSession();

  /// Purpose: Register a new user account.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Purpose: Trigger verification mail delivery for the given account email.
  Future<void> requestEmailVerification({required String email});

  /// Purpose: Confirm account email verification using one-time token.
  Future<void> confirmEmailVerification({required String token});

  /// Purpose: Trigger password reset mail delivery for the given account email.
  Future<void> requestPasswordReset({required String email});

  /// Purpose: Confirm password reset with a one-time token and new password.
  Future<void> confirmPasswordReset({
    required String token,
    required String password,
  });
}

/// Purpose: Implement PocketBase authentication APIs through Dio client.
final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Purpose: Construct remote datasource with external Dio dependency.
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  /// Purpose: Authenticate user credentials using PocketBase users collection.
  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/collections/users/auth-with-password',
      data: <String, dynamic>{'identity': email.trim(), 'password': password},
    );

    final data = response.data ?? const <String, dynamic>{};
    final session = _parseSession(data);
    if (session == null) {
      throw DioException.badResponse(
        statusCode: 502,
        requestOptions: response.requestOptions,
        response: response,
      );
    }

    return session;
  }

  /// Purpose: Refresh token-backed auth session and return latest user flags.
  @override
  Future<AuthSession> refreshSession() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/collections/users/auth-refresh',
    );
    final data = response.data ?? const <String, dynamic>{};
    final session = _parseSession(data);
    if (session == null) {
      throw DioException.badResponse(
        statusCode: 502,
        requestOptions: response.requestOptions,
        response: response,
      );
    }
    return session;
  }

  /// Purpose: Create users collection record using PocketBase built-in endpoint.
  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      '/api/collections/users/records',
      data: <String, dynamic>{
        'email': email.trim(),
        'password': password,
        'passwordConfirm': password,
        'name': name.trim(),
      },
    );
  }

  /// Purpose: Request account verification email without exposing account existence.
  @override
  Future<void> requestEmailVerification({required String email}) async {
    await _dio.post<void>(
      '/api/collections/users/request-verification',
      data: <String, dynamic>{'email': email.trim()},
    );
  }

  /// Purpose: Confirm account email verification token.
  @override
  Future<void> confirmEmailVerification({required String token}) async {
    await _dio.post<void>(
      '/api/collections/users/confirm-verification',
      data: <String, dynamic>{'token': token.trim()},
    );
  }

  /// Purpose: Request password reset email without exposing account existence.
  @override
  Future<void> requestPasswordReset({required String email}) async {
    await _dio.post<void>(
      '/api/collections/users/request-password-reset',
      data: <String, dynamic>{'email': email.trim()},
    );
  }

  /// Purpose: Confirm password reset by token and new password.
  @override
  Future<void> confirmPasswordReset({
    required String token,
    required String password,
  }) async {
    await _dio.post<void>(
      '/api/collections/users/confirm-password-reset',
      data: <String, dynamic>{
        'token': token.trim(),
        'password': password,
        'passwordConfirm': password,
      },
    );
  }

  /// Purpose: Parse auth payload into a typed session, or null when malformed.
  AuthSession? _parseSession(Map<String, dynamic> data) {
    final token = (data['token'] as String?)?.trim() ?? '';
    final record =
        (data['record'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
    final userId = (record['id'] as String?)?.trim() ?? '';
    final userEmail = (record['email'] as String?)?.trim() ?? '';
    final name = (record['name'] as String?)?.trim();
    final isVerified = record['verified'] == true;

    if (token.isEmpty || userId.isEmpty || userEmail.isEmpty) {
      return null;
    }

    return AuthSession(
      token: token,
      userId: userId,
      email: userEmail,
      isVerified: isVerified,
      name: name == null || name.isEmpty ? null : name,
    );
  }
}
