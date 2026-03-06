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
      title: 'Welcome',
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PscSurfaceCard(
              emphasize: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PscInfoPill(
                    label: 'Explainable AI Digest',
                    icon: Icons.auto_awesome_outlined,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'A calmer brief, trained on your rules.',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Set a few preferences and this app will rank what matters, show why it surfaced, and attach the sources behind every summary.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      PscInfoPill(
                        label: 'Traceable citations',
                        icon: Icons.link_outlined,
                        backgroundColor: theme.colorScheme.tertiary.withValues(
                          alpha: 0.1,
                        ),
                        foregroundColor: theme.colorScheme.tertiary,
                      ),
                      PscInfoPill(
                        label: 'Rule-first ranking',
                        icon: Icons.tune_outlined,
                        backgroundColor: theme.colorScheme.secondary.withValues(
                          alpha: 0.16,
                        ),
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PscSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  PscSectionTitle('What You Will Set Up'),
                  SizedBox(height: 14),
                  PscBulletLine(
                    label:
                        'Choose a focused set of topics to guide the ranking order.',
                    icon: Icons.interests_outlined,
                  ),
                  SizedBox(height: 10),
                  PscBulletLine(
                    label: 'Shape which source types earn trust in the feed.',
                    icon: Icons.fact_check_outlined,
                  ),
                  SizedBox(height: 10),
                  PscBulletLine(
                    label:
                        'Adjust tone and cadence before previewing your first brief.',
                    icon: Icons.schedule_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PscStatusBanner(
              message:
                  'Four short steps. You can revise everything later in the rules console.',
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => context.go(AppRoutePath.onboardingTopics),
              child: const Text('Start Personalizing'),
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
