import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../copy/auth_ui_copy.dart';
import '../presenters/auth_error_presenter.dart';
import '../providers/auth_providers.dart';
import '../validation/auth_input_validator.dart';
import '../widgets/auth_support_widgets.dart';

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
        ? AuthErrorPresenter.present(
            authState.error,
            fallbackMessage: AppAuthMessage.accountCreationFailedRetry,
          )
        : null;

    return PscPageScaffold(
      title: AuthUiCopy.createAccountTitle,
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeroCard.fromContent(content: AuthUiCopy.signUpHero),
              const SizedBox(height: 16),
              PscSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PscSectionTitle(AuthUiCopy.accountDetailsSection),
                    const SizedBox(height: 14),
                    AuthNameField(controller: _nameController),
                    const SizedBox(height: 12),
                    AuthEmailField(controller: _emailController),
                    const SizedBox(height: 12),
                    AuthPasswordField(
                      controller: _passwordController,
                      label: AuthUiCopy.passwordLabel,
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
                    if (errorMessage != null) ...[
                      const SizedBox(height: 12),
                      PscStatusBanner(
                        message: errorMessage,
                        color: theme.colorScheme.error,
                      ),
                    ],
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: AuthSubmitButtonChild(
                        isLoading: isLoading,
                        label: AuthUiCopy.createAccountAction,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () => context.go(AppRoutePath.login),
                      child: const Text(AuthUiCopy.backToSignInAction),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
