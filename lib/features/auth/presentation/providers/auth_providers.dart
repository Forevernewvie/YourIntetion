import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/network_providers.dart';
import '../../application/usecases/auth_usecases.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_session_sync.dart';

/// Purpose: Provide local authentication datasource instance.
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return const AuthLocalDataSourceImpl();
});

/// Purpose: Provide remote authentication datasource instance.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.read(dioProvider));
});

/// Purpose: Provide auth repository for sign-in/sign-up/session restore use cases.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: ref.read(authRemoteDataSourceProvider),
    local: ref.read(authLocalDataSourceProvider),
  );
});

/// Purpose: Hold authenticated session lifecycle and expose login/logout actions.
final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

/// Purpose: Provide use case for restoring persisted auth session state.
final restoreSessionUseCaseProvider = Provider<RestoreSessionUseCase>((ref) {
  return RestoreSessionUseCase(ref.read(authRepositoryProvider));
});

/// Purpose: Provide use case for interactive sign-in.
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.read(authRepositoryProvider));
});

/// Purpose: Provide use case for account registration.
final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.read(authRepositoryProvider));
});

/// Purpose: Provide use case for sign-out.
final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.read(authRepositoryProvider));
});

/// Purpose: Provide use case for refreshing authenticated session state.
final refreshSessionUseCaseProvider = Provider<RefreshSessionUseCase>((ref) {
  return RefreshSessionUseCase(ref.read(authRepositoryProvider));
});

/// Purpose: Provide use case for resending verification emails.
final resendVerificationUseCaseProvider = Provider<ResendVerificationUseCase>((
  ref,
) {
  return ResendVerificationUseCase(ref.read(authRepositoryProvider));
});

/// Purpose: Provide use case for confirming verification tokens.
final confirmEmailVerificationUseCaseProvider =
    Provider<ConfirmEmailVerificationUseCase>((ref) {
      return ConfirmEmailVerificationUseCase(ref.read(authRepositoryProvider));
    });

/// Purpose: Provide use case for requesting password reset emails.
final requestPasswordResetUseCaseProvider =
    Provider<RequestPasswordResetUseCase>((ref) {
      return RequestPasswordResetUseCase(ref.read(authRepositoryProvider));
    });

/// Purpose: Provide use case for confirming password reset tokens.
final confirmPasswordResetUseCaseProvider =
    Provider<ConfirmPasswordResetUseCase>((ref) {
      return ConfirmPasswordResetUseCase(ref.read(authRepositoryProvider));
    });

/// Purpose: Manage authenticated session lifecycle with deterministic state transitions.
class AuthController extends AsyncNotifier<AuthSession?> {
  /// Purpose: Restore persisted session during app bootstrap.
  @override
  Future<AuthSession?> build() async {
    final session = await ref.read(restoreSessionUseCaseProvider).call();
    ref.read(authSessionSyncProvider).sync(session);
    AppLogger.info(
      AppAuthLogEvent.bootstrapSession,
      fields: {'authenticated': session != null},
    );
    return session;
  }

  /// Purpose: Execute sign-in flow and update global session state.
  Future<void> signIn({required String email, required String password}) async {
    await _runSessionMutation(() {
      return ref
          .read(signInUseCaseProvider)
          .call(email: email, password: password);
    });
  }

  /// Purpose: Execute sign-up flow and update global session state.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    await _runSessionMutation(() {
      return ref
          .read(signUpUseCaseProvider)
          .call(email: email, password: password, name: name);
    });
  }

  /// Purpose: Execute sign-out flow and clear global session state.
  Future<void> signOut() async {
    await ref.read(signOutUseCaseProvider).call();
    ref.read(authSessionSyncProvider).sync(null);
    state = const AsyncData(null);
  }

  /// Purpose: Request verification email delivery for the current user.
  Future<void> resendVerification({required String email}) {
    return ref.read(resendVerificationUseCaseProvider).call(email: email);
  }

  /// Purpose: Confirm verification token and refresh session verification flags.
  Future<void> confirmEmailVerification({required String token}) async {
    await ref.read(confirmEmailVerificationUseCaseProvider).call(token: token);
    final refreshed = await ref.read(refreshSessionUseCaseProvider).call();
    ref.read(authSessionSyncProvider).sync(refreshed);
    state = AsyncData(refreshed);
  }

  /// Purpose: Request password reset email without exposing account existence.
  Future<void> requestPasswordReset({required String email}) {
    return ref.read(requestPasswordResetUseCaseProvider).call(email: email);
  }

  /// Purpose: Confirm password reset with token and replacement password.
  Future<void> confirmPasswordReset({
    required String token,
    required String password,
  }) {
    return ref
        .read(confirmPasswordResetUseCaseProvider)
        .call(token: token, password: password);
  }

  /// Purpose: Refresh current session state from backend and sync providers.
  Future<void> refreshSession() async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final refreshed = await ref.read(refreshSessionUseCaseProvider).call();
    ref.read(authSessionSyncProvider).sync(refreshed);
    state = AsyncData(refreshed);
  }

  /// Purpose: Execute a session-producing auth action with consistent loading and sync behavior.
  Future<void> _runSessionMutation(
    Future<AuthSession> Function() action,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await action();
      ref.read(authSessionSyncProvider).sync(session);
      return session;
    });
  }
}
