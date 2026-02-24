import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';

/// Purpose: Finalize tone and frequency before first digest generation.
class ToneFrequencyScreen extends StatefulWidget {
  /// Purpose: Create tone and frequency screen widget.
  const ToneFrequencyScreen({super.key});

  /// Purpose: Create mutable state instance.
  @override
  State<ToneFrequencyScreen> createState() => _ToneFrequencyScreenState();
}

/// Purpose: Manage toggles for notification and schedule settings.
class _ToneFrequencyScreenState extends State<ToneFrequencyScreen> {
  bool _digestPreviewEnabled = true;

  /// Purpose: Build tone and frequency configuration interface.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: 'Tone + Frequency',
      body: Column(
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
                ? const Color(0xFF1B8F5A)
                : theme.textTheme.labelSmall?.color,
            onTap: () => setState(() {
              _digestPreviewEnabled = !_digestPreviewEnabled;
            }),
          ),
          const Spacer(),
          FilledButton(
            onPressed: () => context.go('/home'),
            child: const Text('Finish Setup'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go('/onboarding/sources'),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
