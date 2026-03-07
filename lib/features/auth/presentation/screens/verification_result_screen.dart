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

/// Purpose: Resolve verification token links and present success/failure outcome.
class VerificationResultScreen extends ConsumerStatefulWidget {
  /// Purpose: Create verification result screen with optional token payload.
  const VerificationResultScreen({required this.token, super.key});

  final String token;

  /// Purpose: Create mutable verification resolution state.
  @override
  ConsumerState<VerificationResultScreen> createState() =>
      _VerificationResultScreenState();
}

/// Purpose: Manage token verification call and render deterministic status UI.
class _VerificationResultScreenState
    extends ConsumerState<VerificationResultScreen> {
  bool _isLoading = true;
  bool _isSuccess = false;
  String _message = 'Verifying your email...';

  /// Purpose: Resolve verification token immediately after first frame render.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolveToken());
  }

  /// Purpose: Verify token, refresh session, and determine navigation readiness.
  Future<void> _resolveToken() async {
    final token = widget.token.trim();
    if (token.isEmpty) {
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _message = AppAuthMessage.verificationTokenMissing;
      });
      return;
    }

    try {
      await ref
          .read(authControllerProvider.notifier)
          .confirmEmailVerification(token: token);
      setState(() {
        _isLoading = false;
        _isSuccess = true;
        _message = AppAuthMessage.verificationSucceeded;
      });
    } catch (error, stackTrace) {
      AppLogger.error(
        'auth_verification_token_resolution_failed',
        error: error,
        stackTrace: stackTrace,
      );
      final failureMessage = AuthErrorPresenter.present(
        error,
        fallbackMessage: AppAuthMessage.verificationInvalidOrExpired,
      );
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _message = failureMessage;
      });
    }
  }

  /// Purpose: Build verification result UI with safe retry/continue actions.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: 'Email Verification',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PscAdaptiveScrollBody(
              extraBottomPadding: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthHeroCard(
                    eyebrow: _isSuccess
                        ? 'Verification Complete'
                        : 'Verification Review',
                    title: _isSuccess
                        ? 'Your account is ready for guided setup.'
                        : 'This verification link could not be completed.',
                    description: _isSuccess
                        ? 'Email trust has been confirmed. You can continue to topic and source setup now.'
                        : 'Try the verification flow again or request a fresh email link before continuing.',
                  ),
                  const SizedBox(height: 12),
                  Icon(
                    _isSuccess
                        ? Icons.verified_user_outlined
                        : Icons.error_outline,
                    size: 44,
                    color: _isSuccess
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                  PscStatusBanner(
                    message: _message,
                    color: _isSuccess
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () => context.go(
                      _isSuccess
                          ? AppRoutePath.welcome
                          : AppRoutePath.verifyPending,
                    ),
                    child: AuthSubmitButtonChild(
                      isLoading: false,
                      label: _isSuccess
                          ? 'Continue Setup'
                          : 'Back to Verification',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
