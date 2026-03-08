import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/navigation/external_link_service.dart';
import '../../../../core/session/session_providers.dart';
import '../../../../shared/feedback/app_feedback_messenger.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_bottom_nav.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../onboarding/presentation/providers/onboarding_providers.dart';
import '../copy/settings_privacy_copy.dart';

/// Purpose: Render explainability and privacy controls.
class SettingsPrivacyScreen extends ConsumerWidget {
  /// Purpose: Create settings and privacy screen widget.
  const SettingsPrivacyScreen({super.key});

  /// Purpose: Open the public privacy policy and surface deterministic feedback if it fails.
  Future<void> _openPrivacyPolicy(BuildContext context, WidgetRef ref) async {
    final opened = await ref
        .read(externalLinkServiceProvider)
        .openExternal(AppLegalUrl.privacyPolicyUri);

    if (!context.mounted || opened) {
      return;
    }

    AppFeedbackMessenger.showError(
      context,
      message: SettingsPrivacyCopy.privacyPolicyOpenFailed,
      event: 'settings_privacy_policy_open_failed',
      fields: {'url': AppLegalUrl.privacyPolicy},
    );
  }

  /// Purpose: Build settings and privacy interface.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final email = ref.watch(currentUserEmailProvider) ?? 'Not signed in';

    return PscPageScaffold(
      title: SettingsPrivacyCopy.screenTitle,
      bottomNavigation: const PscBottomNav(currentIndex: 3),
      body: ListView(
        children: [
          PscSurfaceCard(
            emphasize: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PscInfoPill(
                  label: SettingsPrivacyCopy.heroEyebrow,
                  icon: Icons.admin_panel_settings_outlined,
                ),
                const SizedBox(height: 16),
                Text(
                  SettingsPrivacyCopy.heroTitle,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  SettingsPrivacyCopy.heroDescription,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PscRuleSectionCard(
            title: SettingsPrivacyCopy.accountTitle,
            description: SettingsPrivacyCopy.accountDescription(email),
            status: SettingsPrivacyCopy.accountStatus,
            hint: SettingsPrivacyCopy.accountHint,
            statusColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          const PscRuleSectionCard(
            title: SettingsPrivacyCopy.privacyControlsTitle,
            description: SettingsPrivacyCopy.privacyControlsDescription,
            status: SettingsPrivacyCopy.privacyControlsStatus,
            hint: SettingsPrivacyCopy.privacyControlsHint,
          ),
          const SizedBox(height: 10),
          PscSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PscSectionTitle(SettingsPrivacyCopy.legalSectionTitle),
                const SizedBox(height: 14),
                Text(
                  SettingsPrivacyCopy.privacyPolicyDescription,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                PscInfoPill(
                  label: SettingsPrivacyCopy.privacyPolicyHostLabel,
                  icon: Icons.public_rounded,
                  backgroundColor: theme.colorScheme.secondary.withValues(
                    alpha: 0.16,
                  ),
                  foregroundColor: theme.colorScheme.onSurface,
                ),
                const SizedBox(height: 14),
                Text(
                  SettingsPrivacyCopy.privacyPolicyUrlLabel,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppLegalUrl.privacyPolicy,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: () => _openPrivacyPolicy(context, ref),
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text(
                    SettingsPrivacyCopy.privacyPolicyOpenAction,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  SettingsPrivacyCopy.privacyPolicyHint,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const PscStateRowCard(
            label: SettingsPrivacyCopy.themeLabel,
            value: SettingsPrivacyCopy.themeValue,
          ),
          const SizedBox(height: 10),
          const PscStateRowCard(
            label: SettingsPrivacyCopy.explainabilityLabel,
            value: SettingsPrivacyCopy.explainabilityValue,
          ),
          const SizedBox(height: 10),
          PscSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PscSectionTitle(SettingsPrivacyCopy.privacyActionsTitle),
                const SizedBox(height: 14),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text(SettingsPrivacyCopy.exportDataAction),
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
                  child: const Text(SettingsPrivacyCopy.replayOnboardingAction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PscStatusBanner(
            message: SettingsPrivacyCopy.deleteWarningMessage,
            color: theme.colorScheme.tertiary,
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
            ),
            child: const Text(SettingsPrivacyCopy.deleteAccountAction),
          ),
          const SizedBox(height: 10),
          FilledButton.tonal(
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
            child: const Text(SettingsPrivacyCopy.signOutAction),
          ),
        ],
      ),
    );
  }
}
