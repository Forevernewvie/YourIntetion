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
import '../validation/auth_input_validator.dart';
import '../widgets/auth_support_widgets.dart';

/// Purpose: Collect account email and trigger password reset mail flow.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  /// Purpose: Create forgot password screen widget.
  const ForgotPasswordScreen({super.key});

  /// Purpose: Create mutable forgot password state.
  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

/// Purpose: Manage email input, reset request call, and feedback messaging.
class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;
  String? _statusMessage;
  bool _isErrorStatus = false;

  /// Purpose: Dispose controller to avoid leaks when widget is removed.
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Purpose: Validate email and request password reset with anti-enumeration UX.
  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _statusMessage = null;
    });

    try {
      await ref
          .read(authControllerProvider.notifier)
          .requestPasswordReset(email: _emailController.text.trim());
      setState(() {
        _isSubmitting = false;
        _isErrorStatus = false;
        _statusMessage = AppAuthMessage.passwordResetRequestSubmitted;
      });
    } catch (error, stackTrace) {
      AppLogger.error(
        'auth_password_reset_request_failed',
        error: error,
        stackTrace: stackTrace,
      );
      final failureMessage = AuthErrorPresenter.present(
        error,
        fallbackMessage: AppAuthMessage.passwordResetRequestFailed,
      );
      setState(() {
        _isSubmitting = false;
        _isErrorStatus = true;
        _statusMessage = failureMessage;
      });
    }
  }

  /// Purpose: Build forgot-password form and deterministic status feedback.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: 'Forgot Password',
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter your email to receive a password reset link.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'you@example.com',
                ),
                validator: AuthInputValidator.validateEmail,
              ),
              if (_statusMessage != null) ...[
                const SizedBox(height: 12),
                PscStatusBanner(
                  message: _statusMessage!,
                  color: _isErrorStatus
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
              ],
              const Spacer(),
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                child: AuthSubmitButtonChild(
                  isLoading: _isSubmitting,
                  label: 'Send Reset Link',
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _isSubmitting
                    ? null
                    : () => context.go(AppRoutePath.login),
                child: const Text('Back to Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
