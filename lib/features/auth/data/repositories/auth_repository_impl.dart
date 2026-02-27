import 'package:dio/dio.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

/// Purpose: Bridge auth domain repository contract with local and remote data sources.
final class AuthRepositoryImpl implements AuthRepository {
  /// Purpose: Construct repository with isolated local/remote dependencies.
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  /// Purpose: Authenticate existing user and persist resulting session.
  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    AppLogger.info('auth_sign_in_requested');
    try {
      final session = await _remote.signIn(email: email, password: password);
      await _local.saveSession(session);
      AppLogger.info(
        'auth_sign_in_succeeded',
        fields: {'userId': session.userId},
      );
      return session;
    } on DioException catch (error) {
      AppLogger.warn(
        'auth_sign_in_failed',
        fields: {'statusCode': error.response?.statusCode},
      );
      throw _mapDioFailure(
        error,
        fallbackMessage: 'Failed to sign in. Please check your credentials.',
      );
    }
  }

  /// Purpose: Create account and then authenticate in one deterministic flow.
  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    AppLogger.info('auth_sign_up_requested');
    try {
      await _remote.signUp(email: email, password: password, name: name);
      final session = await _remote.signIn(email: email, password: password);
      await _local.saveSession(session);
      AppLogger.info(
        'auth_sign_up_succeeded',
        fields: {'userId': session.userId},
      );
      return session;
    } on DioException catch (error) {
      AppLogger.warn(
        'auth_sign_up_failed',
        fields: {'statusCode': error.response?.statusCode},
      );
      throw _mapDioFailure(
        error,
        fallbackMessage: 'Failed to create account. Please retry.',
      );
    }
  }

  /// Purpose: Trigger verification email resend with abuse-safe backend controls.
  @override
  Future<void> resendVerification({required String email}) async {
    try {
      await _remote.requestEmailVerification(email: email);
    } on DioException catch (error) {
      throw _mapDioFailure(
        error,
        fallbackMessage: 'Unable to send verification email. Please retry.',
      );
    }
  }

  /// Purpose: Confirm email verification token and update account verification state.
  @override
  Future<void> confirmEmailVerification({required String token}) async {
    try {
      await _remote.confirmEmailVerification(token: token);
    } on DioException catch (error) {
      throw _mapDioFailure(
        error,
        fallbackMessage: 'Verification link is invalid or expired.',
      );
    }
  }

  /// Purpose: Trigger password reset mail delivery with anti-enumeration messaging.
  @override
  Future<void> requestPasswordReset({required String email}) async {
    try {
      await _remote.requestPasswordReset(email: email);
    } on DioException catch (error) {
      throw _mapDioFailure(
        error,
        fallbackMessage:
            'If the account exists, password reset instructions were sent.',
      );
    }
  }

  /// Purpose: Confirm password reset and invalidate compromised credentials.
  @override
  Future<void> confirmPasswordReset({
    required String token,
    required String password,
  }) async {
    try {
      await _remote.confirmPasswordReset(token: token, password: password);
    } on DioException catch (error) {
      throw _mapDioFailure(
        error,
        fallbackMessage: 'Reset link is invalid or expired.',
      );
    }
  }

  /// Purpose: Refresh authenticated session and persist latest verified/account flags.
  @override
  Future<AuthSession> refreshSession() async {
    try {
      final session = await _remote.refreshSession();
      await _local.saveSession(session);
      return session;
    } on DioException catch (error) {
      throw _mapDioFailure(
        error,
        fallbackMessage: 'Unable to refresh session.',
      );
    }
  }

  /// Purpose: Restore persisted local session without network dependency.
  @override
  Future<AuthSession?> restoreSession() {
    return _local.readSession();
  }

  /// Purpose: Remove local session state for deterministic sign-out behavior.
  @override
  Future<void> signOut() {
    return _local.clearSession();
  }

  /// Purpose: Convert Dio exceptions into normalized app failures for UI handling.
  AppFailure _mapDioFailure(
    DioException error, {
    required String fallbackMessage,
  }) {
    final statusCode = error.response?.statusCode ?? 0;
    if (statusCode == 401 || statusCode == 403) {
      return const AppFailure(
        code: AppErrorCode.netUnauthorized,
        message: 'Authentication failed.',
      );
    }
    if (statusCode == 429) {
      return const AppFailure(
        code: AppErrorCode.apiBadResponse,
        message: 'Too many requests. Please wait and try again.',
      );
    }
    if (statusCode >= 400 && statusCode < 500) {
      return AppFailure(
        code: AppErrorCode.apiBadResponse,
        message: fallbackMessage,
        cause: error,
      );
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const AppFailure(
        code: AppErrorCode.netTimeout,
        message: 'Network timeout while authenticating.',
      );
    }
    return AppFailure(
      code: AppErrorCode.unknown,
      message: fallbackMessage,
      cause: error,
    );
  }
}
