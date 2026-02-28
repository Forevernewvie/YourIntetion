import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../providers/auth_providers.dart';

/// Purpose: Block unverified users and guide them through verification completion.
class EmailVerificationPendingScreen extends ConsumerStatefulWidget {
  /// Purpose: Create email verification pending screen widget.
  const EmailVerificationPendingScreen({super.key});

  /// Purpose: Create mutable cooldown and status state.
  @override
  ConsumerState<EmailVerificationPendingScreen> createState() =>
      _EmailVerificationPendingScreenState();
}

/// Purpose: Manage resend cooldown, verification refresh, and status feedback.
class _EmailVerificationPendingScreenState
    extends ConsumerState<EmailVerificationPendingScreen> {
  static const _resendCooldownSeconds = 60;

  Timer? _cooldownTimer;
  int _remainingSeconds = 0;
  String? _statusMessage;
  bool _isErrorStatus = false;

  /// Purpose: Release timer resources when screen state is disposed.
  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  /// Purpose: Trigger verification email resend and start cooldown window.
  Future<void> _resendVerification() async {
    final session = ref.read(authControllerProvider).valueOrNull;
    final email = session?.email ?? '';
    if (email.isEmpty) {
      setState(() {
        _statusMessage =
            'Unable to determine account email. Please sign in again.';
        _isErrorStatus = true;
      });
      return;
    }

    try {
      await ref
          .read(authControllerProvider.notifier)
          .resendVerification(email: email);
      _startCooldown();
      setState(() {
        _statusMessage = 'Verification email sent. Please check your inbox.';
        _isErrorStatus = false;
      });
    } catch (error) {
      final message = error is AppFailure
          ? error.message
          : 'Unable to send verification email. Please retry.';
      setState(() {
        _statusMessage = message;
        _isErrorStatus = true;
      });
    }
  }

  /// Purpose: Refresh auth session and continue once account is verified.
  Future<void> _iHaveVerified() async {
    try {
      await ref.read(authControllerProvider.notifier).refreshSession();
      final session = ref.read(authControllerProvider).valueOrNull;
      if (!mounted) {
        return;
      }
      if (session?.isVerified == true) {
        context.go(AppRoutePath.welcome);
        return;
      }
      setState(() {
        _statusMessage =
            'Verification is still pending. Please verify and retry.';
        _isErrorStatus = true;
      });
    } catch (error) {
      final message = error is AppFailure
          ? error.message
          : 'Failed to refresh verification status.';
      setState(() {
        _statusMessage = message;
        _isErrorStatus = true;
      });
    }
  }

  /// Purpose: Start and update resend cooldown countdown.
  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() {
      _remainingSeconds = _resendCooldownSeconds;
    });
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds <= 1) {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
        });
        return;
      }
      setState(() {
        _remainingSeconds -= 1;
      });
    });
  }

  /// Purpose: Build verification-pending UI with resend and status refresh actions.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = ref.watch(authControllerProvider).valueOrNull;
    final email = session?.email ?? 'your account email';
    final resendLabel = _remainingSeconds == 0
        ? 'Resend Verification Email'
        : 'Resend in ${_remainingSeconds}s';

    return PscPageScaffold(
      title: 'Verify Your Email',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'We sent a verification link to:',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
          Text(
            email,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Verification is required before you can view personalized digests.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (_statusMessage != null) ...[
            PscStatusBanner(
              message: _statusMessage!,
              color: _isErrorStatus
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
          ],
          FilledButton(
            onPressed: _iHaveVerified,
            child: const Text("I've Verified My Email"),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _remainingSeconds == 0 ? _resendVerification : null,
            child: Text(resendLabel),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () => context.go(AppRoutePath.login),
            child: const Text('Back to Sign In'),
          ),
        ],
      ),
    );
  }
}
