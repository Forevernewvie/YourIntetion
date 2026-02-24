import 'package:dio/dio.dart';

import '../../domain/entities/auth_session.dart';

/// Purpose: Define remote authentication API contract.
abstract interface class AuthRemoteDataSource {
  /// Purpose: Authenticate a user and return backend auth session payload.
  Future<AuthSession> signIn({required String email, required String password});

  /// Purpose: Register a new user account.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
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
    final token = (data['token'] as String?)?.trim() ?? '';
    final record =
        (data['record'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
    final userId = (record['id'] as String?)?.trim() ?? '';
    final userEmail = (record['email'] as String?)?.trim() ?? '';
    final name = (record['name'] as String?)?.trim();

    if (token.isEmpty || userId.isEmpty || userEmail.isEmpty) {
      throw DioException.badResponse(
        statusCode: 502,
        requestOptions: response.requestOptions,
        response: response,
      );
    }

    return AuthSession(
      token: token,
      userId: userId,
      email: userEmail,
      name: name == null || name.isEmpty ? null : name,
    );
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
}
