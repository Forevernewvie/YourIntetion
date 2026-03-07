import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../presenters/auth_error_presenter.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_support_widgets.dart';

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
      AppLogger.warn('auth_verification_resend_missing_email');
      setState(() {
        _statusMessage = AppAuthMessage.verificationEmailMissing;
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
        _statusMessage = AppAuthMessage.verificationEmailSent;
        _isErrorStatus = false;
      });
    } catch (error, stackTrace) {
      AppLogger.error(
        'auth_verification_resend_failed',
        error: error,
        stackTrace: stackTrace,
      );
      final message = AuthErrorPresenter.present(
        error,
        fallbackMessage: AppAuthMessage.verificationSendFailed,
      );
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
        _statusMessage = AppAuthMessage.verificationStillPending;
        _isErrorStatus = true;
      });
    } catch (error, stackTrace) {
      AppLogger.error(
        'auth_verification_refresh_failed',
        error: error,
        stackTrace: stackTrace,
      );
      final message = AuthErrorPresenter.present(
        error,
        fallbackMessage: AppAuthMessage.verificationStatusRefreshFailed,
      );
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
      _remainingSeconds = AppAuthPolicy.resendCooldownSeconds;
    });
    _cooldownTimer = Timer.periodic(AppUiDuration.oneSecond, (timer) {
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
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
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
              child: const AuthSubmitButtonChild(
                isLoading: false,
                label: "I've Verified My Email",
              ),
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
      ),
    );
  }
}
