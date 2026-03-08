import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../copy/auth_ui_copy.dart';
import '../presenters/auth_error_presenter.dart';
import '../providers/auth_providers.dart';
import '../validation/auth_input_validator.dart';
import '../widgets/auth_support_widgets.dart';

/// Purpose: Validate reset token and set a new password for account recovery.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  /// Purpose: Create reset password screen with optional deep-link token.
  const ResetPasswordScreen({required this.initialToken, super.key});

  final String initialToken;

  /// Purpose: Create mutable reset password state.
  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

/// Purpose: Manage reset token/password validation and submission state.
class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _isSubmitting = false;
  String? _statusMessage;
  bool _isErrorStatus = false;

  /// Purpose: Seed token input from route parameter for deep-link compatibility.
  @override
  void initState() {
    super.initState();
    _tokenController.text = widget.initialToken;
  }

  /// Purpose: Dispose form controllers when screen is removed.
  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  /// Purpose: Validate reset inputs and submit password reset confirmation.
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
          .confirmPasswordReset(
            token: _tokenController.text.trim(),
            password: _passwordController.text,
          );
      setState(() {
        _isSubmitting = false;
        _isErrorStatus = false;
        _statusMessage = AppAuthMessage.passwordResetComplete;
      });
    } catch (error, stackTrace) {
      AppLogger.error(
        AppAuthLogEvent.passwordResetConfirmFailed,
        error: error,
        stackTrace: stackTrace,
      );
      final failureMessage = AuthErrorPresenter.present(
        error,
        fallbackMessage: AppAuthMessage.passwordResetFailed,
      );
      setState(() {
        _isSubmitting = false;
        _isErrorStatus = true;
        _statusMessage = failureMessage;
      });
    }
  }

  /// Purpose: Build reset-password form and deterministic success/failure guidance.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: AuthUiCopy.resetPasswordTitle,
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AuthUiCopy.resetPasswordDescription,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _tokenController,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: AuthUiCopy.resetTokenLabel,
                ),
                validator: AuthInputValidator.validateResetToken,
              ),
              const SizedBox(height: 12),
              AuthPasswordField(
                controller: _passwordController,
                label: AuthUiCopy.newPasswordLabel,
                obscureText: _obscurePassword,
                onToggleVisibility: () => setState(() {
                  _obscurePassword = !_obscurePassword;
                }),
                validator: AuthInputValidator.validatePassword,
              ),
              const SizedBox(height: 12),
              AuthPasswordField(
                controller: _confirmController,
                label: AuthUiCopy.confirmPasswordLabel,
                obscureText: _obscurePassword,
                onToggleVisibility: () => setState(() {
                  _obscurePassword = !_obscurePassword;
                }),
                validator: (value) =>
                    AuthInputValidator.validatePasswordConfirmation(
                      value,
                      password: _passwordController.text,
                    ),
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
                  label: AuthUiCopy.resetPasswordAction,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _isSubmitting
                    ? null
                    : () => context.go(AppRoutePath.login),
                child: const Text(AuthUiCopy.backToSignInAction),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
