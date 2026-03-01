import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../providers/auth_providers.dart';

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
        _message = 'Verification link is missing a token.';
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
        _message = 'Email verified successfully. You can continue setup.';
      });
    } catch (error) {
      final failureMessage = error is AppFailure
          ? error.message
          : 'Verification link is invalid or expired.';
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
                  const SizedBox(height: 12),
                  Text(
                    _isSuccess
                        ? 'Verification Complete'
                        : 'Verification Failed',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                    child: Text(
                      _isSuccess ? 'Continue Setup' : 'Back to Verification',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
