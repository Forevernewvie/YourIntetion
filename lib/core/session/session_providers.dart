import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Purpose: Hold current authenticated access token for request authorization.
final accessTokenProvider = StateProvider<String?>((ref) => null);

/// Purpose: Hold current authenticated user id for app-level personalization.
final currentUserIdProvider = StateProvider<String?>((ref) => null);

/// Purpose: Hold current authenticated user email for UI/account context.
final currentUserEmailProvider = StateProvider<String?>((ref) => null);

/// Purpose: Hold current email verification status for auth gating.
final currentUserVerifiedProvider = StateProvider<bool>((ref) => false);
