import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/session/session_providers.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_bottom_nav.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../onboarding/presentation/providers/onboarding_providers.dart';

/// Purpose: Render explainability and privacy controls.
class SettingsPrivacyScreen extends ConsumerWidget {
  /// Purpose: Create settings and privacy screen widget.
  const SettingsPrivacyScreen({super.key});

  /// Purpose: Build settings and privacy interface.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final email = ref.watch(currentUserEmailProvider) ?? 'Not signed in';

    return PscPageScaffold(
      title: 'Settings & Privacy',
      bottomNavigation: const PscBottomNav(currentIndex: 3),
      body: ListView(
        children: [
          PscSurfaceCard(
            emphasize: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PscInfoPill(
                  label: 'Accessible Controls',
                  icon: Icons.admin_panel_settings_outlined,
                ),
                const SizedBox(height: 16),
                Text(
                  'Keep trust visible, not hidden in menus.',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'This area governs account state, transparency controls, and how much of the digest system remains visible and adjustable to you.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PscRuleSectionCard(
            title: 'Account',
            description: '$email • locale • digest timezone',
            status: 'Configured',
            hint: 'Profile and identity state',
            statusColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          const PscRuleSectionCard(
            title: 'Privacy Controls',
            description: 'Data export, account deletion, and consent history.',
            status: 'Transparent',
            hint: 'Designed to keep control explicit',
          ),
          const SizedBox(height: 10),
          const PscStateRowCard(label: 'Theme', value: 'System (Light / Dark)'),
          const SizedBox(height: 10),
          const PscStateRowCard(
            label: 'Explainability mode',
            value: 'Always visible',
          ),
          const SizedBox(height: 10),
          PscSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PscSectionTitle('Privacy Actions'),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Export My Data'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () async {
                    await ref.read(onboardingStatusProvider.notifier).reset();
                    if (!context.mounted) {
                      return;
                    }
                    context.go(AppRoutePath.welcome);
                  },
                  child: const Text('Replay Onboarding'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PscStatusBanner(
            message:
                'Account deletion is intentionally separated from routine actions to reduce destructive mistakes.',
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
            ),
            child: const Text('Delete Account'),
          ),
          const SizedBox(height: 10),
          FilledButton.tonal(
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
