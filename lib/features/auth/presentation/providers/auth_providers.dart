import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/logging/app_logger.dart';
import '../../../../core/network/network_providers.dart';
import '../../../../core/session/session_providers.dart';
import '../../data/datasources/auth_local_data_source.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

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

/// Purpose: Manage authenticated session lifecycle with deterministic state transitions.
class AuthController extends AsyncNotifier<AuthSession?> {
  /// Purpose: Restore persisted session during app bootstrap.
  @override
  Future<AuthSession?> build() async {
    final repository = ref.read(authRepositoryProvider);
    final session = await repository.restoreSession();
    _syncSessionProviders(session);
    AppLogger.info(
      'auth_bootstrap_session',
      fields: {'authenticated': session != null},
    );
    return session;
  }

  /// Purpose: Execute sign-in flow and update global session state.
  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
      _syncSessionProviders(session);
      return session;
    });
  }

  /// Purpose: Execute sign-up flow and update global session state.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await ref
          .read(authRepositoryProvider)
          .signUp(email: email, password: password, name: name);
      _syncSessionProviders(session);
      return session;
    });
  }

  /// Purpose: Execute sign-out flow and clear global session state.
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    _syncSessionProviders(null);
    state = const AsyncData(null);
  }

  /// Purpose: Request verification email delivery for the current user.
  Future<void> resendVerification({required String email}) {
    return ref.read(authRepositoryProvider).resendVerification(email: email);
  }

  /// Purpose: Confirm verification token and refresh session verification flags.
  Future<void> confirmEmailVerification({required String token}) async {
    await ref
        .read(authRepositoryProvider)
        .confirmEmailVerification(token: token);
    final refreshed = await ref.read(authRepositoryProvider).refreshSession();
    _syncSessionProviders(refreshed);
    state = AsyncData(refreshed);
  }

  /// Purpose: Request password reset email without exposing account existence.
  Future<void> requestPasswordReset({required String email}) {
    return ref.read(authRepositoryProvider).requestPasswordReset(email: email);
  }

  /// Purpose: Confirm password reset with token and replacement password.
  Future<void> confirmPasswordReset({
    required String token,
    required String password,
  }) {
    return ref
        .read(authRepositoryProvider)
        .confirmPasswordReset(token: token, password: password);
  }

  /// Purpose: Refresh current session state from backend and sync providers.
  Future<void> refreshSession() async {
    final current = state.valueOrNull;
    if (current == null) {
      return;
    }
    final refreshed = await ref.read(authRepositoryProvider).refreshSession();
    _syncSessionProviders(refreshed);
    state = AsyncData(refreshed);
  }

  /// Purpose: Synchronize core session providers used by router and networking.
  void _syncSessionProviders(AuthSession? session) {
    ref.read(accessTokenProvider.notifier).state = session?.token;
    ref.read(currentUserIdProvider.notifier).state = session?.userId;
    ref.read(currentUserEmailProvider.notifier).state = session?.email;
    ref.read(currentUserVerifiedProvider.notifier).state =
        session?.isVerified ?? false;
  }
}
