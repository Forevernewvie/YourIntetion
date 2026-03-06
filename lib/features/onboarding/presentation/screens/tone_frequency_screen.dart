import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/layout/psc_adaptive_scroll_body.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
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
      title: 'Tone & Frequency',
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PscStepHeader(
              step: 3,
              totalSteps: 4,
              title: 'Set how the brief should sound and arrive.',
              description:
                  'Choose a cadence that feels sustainable. The goal is a digest you actually return to, not another noisy notification stream.',
              tags: ['Daily by default', 'Tone can evolve'],
            ),
            const SizedBox(height: 16),
            PscSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PscSectionTitle('Digest Tone'),
                  const SizedBox(height: 12),
                  Text(
                    'Neutral is the default because it lowers cognitive load while keeping room for analytical context when a story needs it.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      PscInfoPill(
                        label: 'Neutral',
                        icon: Icons.radio_button_checked,
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      PscInfoPill(
                        label: 'Analytical',
                        icon: Icons.analytics_outlined,
                        backgroundColor: theme.colorScheme.secondary.withValues(
                          alpha: 0.18,
                        ),
                        foregroundColor: theme.colorScheme.onSurface,
                      ),
                      PscInfoPill(
                        label: 'Brief',
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
              title: 'Delivery Cadence',
              description:
                  'Daily 08:00 brief with a weekly deeper scan on Friday.',
              status: 'Active',
              hint: 'Designed for a calm, predictable reading habit',
            ),
            const SizedBox(height: 10),
            PscStateRowCard(
              label: 'Preview digest alert',
              value: _digestPreviewEnabled ? 'ON' : 'OFF',
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
              child: const Text('Finish & Preview Digest'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => context.go(AppRoutePath.onboardingSources),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
