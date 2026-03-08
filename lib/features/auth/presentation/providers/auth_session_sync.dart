import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/session_providers.dart';
import '../../domain/entities/auth_session.dart';

/// Purpose: Provide session synchronizer to isolate global session provider updates.
final authSessionSyncProvider = Provider<AuthSessionSync>((ref) {
  return AuthSessionSync(ref);
});

/// Purpose: Synchronize auth session snapshots into app-level session providers.
final class AuthSessionSync {
  /// Purpose: Construct synchronizer with provider container dependency.
  const AuthSessionSync(this._ref);

  final Ref _ref;

  /// Purpose: Push session values into app-wide providers used by routing and networking.
  void sync(AuthSession? session) {
    _ref.read(accessTokenProvider.notifier).state = session?.token;
    _ref.read(currentUserIdProvider.notifier).state = session?.userId;
    _ref.read(currentUserEmailProvider.notifier).state = session?.email;
    _ref.read(currentUserVerifiedProvider.notifier).state =
        session?.isVerified ?? false;
  }
}
