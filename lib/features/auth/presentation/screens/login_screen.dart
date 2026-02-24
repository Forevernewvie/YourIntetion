import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/app_failure.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../providers/auth_providers.dart';

/// Purpose: Render login form for authenticated app access.
class LoginScreen extends ConsumerStatefulWidget {
  /// Purpose: Create login screen widget.
  const LoginScreen({super.key});

  /// Purpose: Create mutable login form state.
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

/// Purpose: Manage login form lifecycle and submit actions.
class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  /// Purpose: Release form controllers when widget state is disposed.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Purpose: Validate form and trigger sign-in flow.
  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  /// Purpose: Build login form and status feedback.
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final theme = Theme.of(context);
    final errorMessage = authState.hasError
        ? _errorMessage(authState.error)
        : null;

    return PscPageScaffold(
      title: 'Sign In',
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Control your digest with explicit rules.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
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
                  : const Text('Sign In'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: isLoading ? null : () => context.go('/signup'),
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }

  /// Purpose: Convert auth state error to a concise UI-friendly message.
  String _errorMessage(Object? error) {
    if (error is AppFailure) {
      return error.message;
    }
    return 'Authentication request failed. Please retry.';
  }
}
