import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../copy/onboarding_ui_copy.dart';
import '../providers/onboarding_providers.dart';

/// Purpose: Finalize tone and frequency before first digest generation.
class ToneFrequencyScreen extends ConsumerStatefulWidget {
  /// Purpose: Create tone and frequency screen widget.
  const ToneFrequencyScreen({super.key});

  /// Purpose: Create mutable state instance.
  @override
  ConsumerState<ToneFrequencyScreen> createState() =>
      _ToneFrequencyScreenState();
}

/// Purpose: Manage toggles for notification and schedule settings.
class _ToneFrequencyScreenState extends ConsumerState<ToneFrequencyScreen> {
  bool _digestPreviewEnabled = true;

  /// Purpose: Persist onboarding completion and route user to first digest preview.
  Future<void> _finishOnboarding() async {
    await ref.read(onboardingStatusProvider.notifier).markCompleted();
    if (!mounted) {
      return;
    }
    context.go(AppRoutePath.onboardingPreview);
  }

  /// Purpose: Build tone and frequency configuration interface.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: OnboardingUiCopy.toneFrequencyTitle,
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PscStepHeader(
              step: 3,
              totalSteps: AppOnboardingPolicy.totalSteps,
              title: OnboardingUiCopy.toneStep.title,
              description: OnboardingUiCopy.toneStep.description,
              tags: OnboardingUiCopy.toneStep.tags,
            ),
            const SizedBox(height: 16),
            PscSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PscSectionTitle(
                    OnboardingUiCopy.digestToneSectionTitle,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    OnboardingUiCopy.digestToneDescription,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      PscInfoPill(
                        label: OnboardingUiCopy.toneNeutral,
                        icon: Icons.radio_button_checked,
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      PscInfoPill(
                        label: OnboardingUiCopy.toneAnalytical,
                        icon: Icons.analytics_outlined,
                        backgroundColor: theme.colorScheme.secondary.withValues(
                          alpha: 0.18,
                        ),
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      PscInfoPill(
                        label: OnboardingUiCopy.toneBrief,
                        icon: Icons.short_text_rounded,
                        backgroundColor: theme.colorScheme.secondary.withValues(
                          alpha: 0.18,
                        ),
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const PscRuleSectionCard(
              title: OnboardingUiCopy.deliveryCadenceTitle,
              description: OnboardingUiCopy.deliveryCadenceDescription,
              status: OnboardingUiCopy.deliveryCadenceStatus,
              hint: OnboardingUiCopy.deliveryCadenceHint,
            ),
            const SizedBox(height: 10),
            PscStateRowCard(
              label: OnboardingUiCopy.previewDigestAlertLabel,
              value: _digestPreviewEnabled
                  ? OnboardingUiCopy.previewAlertOn
                  : OnboardingUiCopy.previewAlertOff,
              valueColor: _digestPreviewEnabled
                  ? theme.colorScheme.primary
                  : theme.textTheme.labelSmall?.color,
              onTap: () => setState(() {
                _digestPreviewEnabled = !_digestPreviewEnabled;
              }),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: _finishOnboarding,
              child: const Text(OnboardingUiCopy.finishPreviewAction),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.onboardingSources),
              child: const Text(OnboardingUiCopy.backAction),
            ),
          ],
        ),
      ),
    );
  }
}
