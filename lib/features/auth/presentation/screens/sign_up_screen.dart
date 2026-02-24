import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../providers/auth_providers.dart';

/// Purpose: Render account registration form for first-time users.
class SignUpScreen extends ConsumerStatefulWidget {
  /// Purpose: Create sign-up screen widget.
  const SignUpScreen({super.key});

  /// Purpose: Create mutable sign-up form state.
  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

/// Purpose: Manage sign-up form state and account creation actions.
class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;

  /// Purpose: Release form controllers when widget state is disposed.
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  /// Purpose: Validate form and trigger sign-up flow.
  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
        );
  }

  /// Purpose: Build sign-up form and action controls.
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final theme = Theme.of(context);
    final errorMessage = authState.hasError
        ? _errorMessage(authState.error)
        : null;

    return PscPageScaffold(
      title: 'Create Account',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Set up your personal rule-driven digest workspace.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                final input = (value ?? '').trim();
                if (input.isEmpty) {
                  return 'Name is required.';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'you@example.com',
              ),
              validator: (value) {
                final input = (value ?? '').trim();
                if (input.isEmpty || !input.contains('@')) {
                  return 'Enter a valid email address.';
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
                labelText: 'Password',
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
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              validator: (value) {
                if ((value ?? '') != _passwordController.text) {
                  return 'Password confirmation does not match.';
                }
                return null;
              },
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                errorMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
            const Spacer(),
            FilledButton(
              onPressed: isLoading ? null : _submit,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Account'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: isLoading ? null : () => context.go('/login'),
              child: const Text('Back to Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Convert auth state error to concise and user-friendly text.
  String _errorMessage(Object? error) {
    if (error is AppFailure) {
      return error.message;
    }
    return 'Account creation failed. Please retry.';
  }
}
