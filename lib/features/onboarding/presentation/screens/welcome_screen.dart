import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';

/// Purpose: Introduce product value and trust model before onboarding setup.
class WelcomeScreen extends StatelessWidget {
  /// Purpose: Create welcome screen widget.
  const WelcomeScreen({super.key});

  /// Purpose: Build welcome page UI and onboarding entry actions.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: 'Preference Summary Curator',
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Text(
                      'Calm summaries. Your rules.',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'You choose topics, tone, frequency, and sources.',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Explainability by default',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const PscSectionTitle('Trust Primer'),
            const SizedBox(height: 8),
            Text(
              'Every digest item explains why it appears and links to traceable sources.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context.go(AppRoutePath.onboardingTopics),
              child: const Text('Start Setup'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.onboardingPreview),
              child: const Text('Preview Sample Digest'),
            ),
          ],
        ),
      ),
    );
  }
}
