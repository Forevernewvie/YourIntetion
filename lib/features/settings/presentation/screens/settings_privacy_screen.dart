import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/session/session_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../onboarding/presentation/providers/onboarding_providers.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_bottom_nav.dart';

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
      title: 'Settings + Privacy',
      bottomNavigation: const PscBottomNav(currentIndex: 3),
      body: ListView(
        children: [
          PscRuleSectionCard(
            title: 'Account',
            description: '$email • locale • digest timezone',
            status: 'Configured',
            hint: 'Manage profile',
            statusColor: const Color(0xFF1B8F5A),
          ),
          const SizedBox(height: 8),
          const PscRuleSectionCard(
            title: 'Privacy Controls',
            description: 'Data export, erase, consent history',
            status: 'Required',
            hint: 'ISO-aligned transparency',
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () {}, child: const Text('Export My Data')),
          const SizedBox(height: 8),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: theme.colorScheme.error),
            ),
            child: Center(
              child: Text(
                'Delete Account',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const PscStateRowCard(label: 'Theme', value: 'System (Light/Dark)'),
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
          const SizedBox(height: 12),
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
