import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../copy/onboarding_ui_copy.dart';

/// Purpose: Introduce product value and trust model before onboarding setup.
class WelcomeScreen extends StatelessWidget {
  /// Purpose: Create welcome screen widget.
  const WelcomeScreen({super.key});

  /// Purpose: Build welcome page UI and onboarding entry actions.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: OnboardingUiCopy.welcomeTitle,
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
                    label: OnboardingUiCopy.welcomeEyebrow,
                    icon: Icons.auto_awesome_outlined,
                  ),
                  const SizedBox(height: AppUiSpacing.section),
                  Text(
                    OnboardingUiCopy.welcomeHeadline,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppUiSpacing.md),
                  Text(
                    OnboardingUiCopy.welcomeDescription,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppUiSpacing.section),
                  Wrap(
                    spacing: AppUiSpacing.sm,
                    runSpacing: AppUiSpacing.sm,
                    children: [
                      PscInfoPill(
                        label: OnboardingUiCopy.welcomeSignalTraceable,
                        icon: Icons.link_outlined,
                        backgroundColor: theme.colorScheme.tertiary.withValues(
                          alpha: 0.1,
                        ),
                        foregroundColor: theme.colorScheme.tertiary,
                      ),
                      PscInfoPill(
                        label: OnboardingUiCopy.welcomeSignalRules,
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
                children: [
                  const PscSectionTitle(OnboardingUiCopy.setupSectionTitle),
                  const SizedBox(height: 14),
                  for (
                    var index = 0;
                    index < OnboardingUiCopy.welcomeSetupBullets.length;
                    index++
                  ) ...[
                    PscBulletLine(
                      label: OnboardingUiCopy.welcomeSetupBullets[index].label,
                      icon: OnboardingUiCopy.welcomeSetupBullets[index].icon,
                    ),
                    if (index !=
                        OnboardingUiCopy.welcomeSetupBullets.length - 1)
                      const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            PscStatusBanner(
              message: OnboardingUiCopy.setupStatusMessage,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => context.go(AppRoutePath.onboardingTopics),
              child: const Text(OnboardingUiCopy.startPersonalizingAction),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.onboardingPreview),
              child: const Text(OnboardingUiCopy.previewSampleDigestAction),
            ),
          ],
        ),
      ),
    );
  }
}
