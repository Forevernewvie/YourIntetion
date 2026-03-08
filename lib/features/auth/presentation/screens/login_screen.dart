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
import '../widgets/auth_support_widgets.dart';

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
        ? AuthErrorPresenter.present(
            authState.error,
            fallbackMessage: AppAuthMessage.authFailedRetry,
          )
        : null;

    return PscPageScaffold(
      title: AuthUiCopy.signInTitle,
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthHeroCard.fromContent(content: AuthUiCopy.loginHero),
              const SizedBox(height: 16),
              PscSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PscSectionTitle(AuthUiCopy.yourAccountSection),
                    const SizedBox(height: 14),
                    AuthEmailField(controller: _emailController),
                    const SizedBox(height: 12),
                    AuthPasswordField(
                      controller: _passwordController,
                      label: AuthUiCopy.passwordLabel,
                      obscureText: _obscurePassword,
                      onToggleVisibility: () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () => context.go(AppRoutePath.forgotPassword),
                        child: const Text(AuthUiCopy.forgotPasswordAction),
                      ),
                    ),
                    if (errorMessage != null) ...[
                      PscStatusBanner(
                        message: errorMessage,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 12),
                    ],
                    FilledButton(
                      onPressed: isLoading ? null : _submit,
                      child: AuthSubmitButtonChild(
                        isLoading: isLoading,
                        label: AuthUiCopy.signInAction,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () => context.go(AppRoutePath.signUp),
                      child: const Text(AuthUiCopy.createAccountAction),
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
