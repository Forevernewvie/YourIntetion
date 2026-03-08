import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../copy/auth_ui_copy.dart';
import '../validation/auth_input_validator.dart';

/// Purpose: Render a reusable hero panel for auth entry screens.
class AuthHeroCard extends StatelessWidget {
  /// Purpose: Construct auth hero panel with optional supporting bullet points.
  const AuthHeroCard({
    required this.eyebrow,
    required this.title,
    required this.description,
    this.points = const [],
    super.key,
  });

  /// Purpose: Construct auth hero panel directly from centralized hero content.
  AuthHeroCard.fromContent({required AuthHeroContent content, super.key})
    : eyebrow = content.eyebrow,
      title = content.title,
      description = content.description,
      points = content.points;

  final String eyebrow;
  final String title;
  final String description;
  final List<AuthHeroPointContent> points;

  /// Purpose: Build auth hero panel with deterministic editorial styling.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PscSurfaceCard(
      emphasize: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PscInfoPill(
            label: eyebrow,
            icon: Icons.menu_book_outlined,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            foregroundColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppUiSpacing.xxl),
          Text(title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppUiSpacing.md),
          Text(description, style: theme.textTheme.bodyMedium),
          if (points.isNotEmpty) ...[
            const SizedBox(height: AppUiSpacing.xxl),
            for (var index = 0; index < points.length; index++) ...[
              PscBulletLine(
                label: points[index].label,
                icon: points[index].icon,
              ),
              if (index != points.length - 1)
                const SizedBox(height: AppUiSpacing.sm),
            ],
          ],
        ],
      ),
    );
  }
}

/// Purpose: Render a consistent password field across auth-related forms.
class AuthPasswordField extends StatelessWidget {
  /// Purpose: Construct password input with shared visibility toggle behavior.
  const AuthPasswordField({
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.onToggleVisibility,
    this.validator = AuthInputValidator.validatePassword,
    this.autofillHints,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final FormFieldValidator<String> validator;
  final Iterable<String>? autofillHints;

  /// Purpose: Build password field with consistent validation and suffix control.
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      autocorrect: false,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
      validator: validator,
    );
  }
}

/// Purpose: Render a shared email input field across auth flows.
class AuthEmailField extends StatelessWidget {
  /// Purpose: Construct email input with shared keyboard and validation behavior.
  const AuthEmailField({
    required this.controller,
    this.label = AuthUiCopy.emailLabel,
    this.hintText = AuthUiCopy.emailHint,
    this.validator = AuthInputValidator.validateEmail,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final FormFieldValidator<String> validator;

  /// Purpose: Build email field with consistent decoration and validation.
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(labelText: label, hintText: hintText),
      validator: validator,
    );
  }
}

/// Purpose: Render a shared name input field across auth flows.
class AuthNameField extends StatelessWidget {
  /// Purpose: Construct name input with shared label and validation behavior.
  const AuthNameField({
    required this.controller,
    this.label = AuthUiCopy.nameLabel,
    this.validator = AuthInputValidator.validateName,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String> validator;

  /// Purpose: Build name field with consistent decoration and validation.
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }
}

/// Purpose: Render a shared loading/label child for auth submit buttons.
class AuthSubmitButtonChild extends StatelessWidget {
  /// Purpose: Construct auth button content from loading state and label.
  const AuthSubmitButtonChild({
    required this.isLoading,
    required this.label,
    super.key,
  });

  final bool isLoading;
  final String label;

  /// Purpose: Build spinner or label without duplicating button child logic.
  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return Text(label);
    }

    return const SizedBox(
      width: AppUiSize.feedbackSpinner,
      height: AppUiSize.feedbackSpinner,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
