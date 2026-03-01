import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/error/app_failure.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../providers/auth_providers.dart';

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
        _statusMessage =
            'Password reset complete. Please sign in with your new password.';
      });
    } catch (error) {
      final failureMessage = error is AppFailure
          ? error.message
          : 'Unable to reset password. Please retry.';
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
      title: 'Reset Password',
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Paste your reset token and choose a new password.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _tokenController,
                autocorrect: false,
                decoration: const InputDecoration(labelText: 'Reset Token'),
                validator: (value) {
                  final input = (value ?? '').trim();
                  if (input.isEmpty) {
                    return 'Reset token is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      _obscurePassword = !_obscurePassword;
                    }),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  final input = value ?? '';
                  if (input.length < 8) {
                    return 'Password must be at least 8 characters.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                obscureText: _obscurePassword,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                validator: (value) {
                  if ((value ?? '') != _passwordController.text) {
                    return 'Password confirmation does not match.';
                  }
                  return null;
                },
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
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Reset Password'),
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
