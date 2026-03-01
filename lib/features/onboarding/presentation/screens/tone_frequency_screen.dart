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
      title: 'Tone + Frequency',
      body: PscAdaptiveScrollBody(
        extraBottomPadding: 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PscRuleSectionCard(
              title: 'Digest Tone',
              description: 'Neutral / Analytical / Brief',
              status: 'Neutral',
              hint: 'Why: lowest cognitive load',
            ),
            const SizedBox(height: 8),
            const PscRuleSectionCard(
              title: 'Frequency',
              description: 'Daily 08:00 + Weekly Deep Dive',
              status: 'Active',
              hint: 'Edit in Notification Preferences',
            ),
            const SizedBox(height: 8),
            PscStateRowCard(
              label: 'Digest alert preview',
              value: _digestPreviewEnabled ? 'ON' : 'OFF',
              valueColor: _digestPreviewEnabled
                  ? theme.colorScheme.primary
                  : theme.textTheme.labelSmall?.color,
              onTap: () => setState(() {
                _digestPreviewEnabled = !_digestPreviewEnabled;
              }),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _finishOnboarding,
              child: const Text('Finish Setup'),
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
