import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/dio_failure_mapper.dart';
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
    AppLogger.info(AppAuthLogEvent.signInRequested);
    try {
      final session = await _remote.signIn(email: email, password: password);
      await _local.saveSession(session);
      AppLogger.info(
        AppAuthLogEvent.signInSucceeded,
        fields: {'userId': session.userId},
      );
      return session;
    } on DioException catch (error) {
      AppLogger.warn(
        AppAuthLogEvent.signInFailed,
        fields: {'statusCode': error.response?.statusCode},
      );
      throw _mapDioFailure(error, fallbackMessage: AppAuthMessage.signInFailed);
    }
  }

  /// Purpose: Create account and then authenticate in one deterministic flow.
  @override
  Future<AuthSession> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    AppLogger.info(AppAuthLogEvent.signUpRequested);
    try {
      await _remote.signUp(email: email, password: password, name: name);
      final session = await _remote.signIn(email: email, password: password);
      await _local.saveSession(session);
      AppLogger.info(
        AppAuthLogEvent.signUpSucceeded,
        fields: {'userId': session.userId},
      );
      return session;
    } on DioException catch (error) {
      AppLogger.warn(
        AppAuthLogEvent.signUpFailed,
        fields: {'statusCode': error.response?.statusCode},
      );
      throw _mapDioFailure(error, fallbackMessage: AppAuthMessage.signUpFailed);
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
        fallbackMessage: AppAuthMessage.verificationSendFailed,
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
        fallbackMessage: AppAuthMessage.verificationInvalidOrExpired,
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
        fallbackMessage: AppAuthMessage.passwordResetRequestSubmitted,
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
        fallbackMessage: AppAuthMessage.passwordResetInvalidOrExpired,
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
        fallbackMessage: AppAuthMessage.sessionRefreshFailed,
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
    return DioFailureMapper.map(
      error,
      messages: DioFailureMessages(
        fallbackMessage: fallbackMessage,
        timeoutMessage: AppAuthMessage.authTimeout,
        unauthorizedMessage: AppAuthMessage.authUnauthorized,
        tooManyRequestsMessage: AppAuthMessage.authTooManyRequests,
      ),
    );
  }
}
