import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/psc_blocks.dart';

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

  final String eyebrow;
  final String title;
  final String description;
  final List<AuthHeroPoint> points;

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

/// Purpose: Describe a single supporting message inside an auth hero panel.
class AuthHeroPoint {
  /// Purpose: Construct auth hero bullet content.
  const AuthHeroPoint({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

/// Purpose: Render a consistent password field across auth-related forms.
class AuthPasswordField extends StatelessWidget {
  /// Purpose: Construct password input with shared visibility toggle behavior.
  const AuthPasswordField({
    required this.controller,
    required this.label,
    required this.obscureText,
    required this.onToggleVisibility,
    required this.validator,
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
