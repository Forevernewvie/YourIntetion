import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/feedback/app_feedback_messenger.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_bottom_nav.dart';

/// Purpose: Render notification schedule and quiet-hour preferences.
class NotificationPreferencesScreen extends StatefulWidget {
  /// Purpose: Create notification preferences screen widget.
  const NotificationPreferencesScreen({super.key});

  /// Purpose: Create mutable state instance.
  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

/// Purpose: Manage toggle state for notification options.
class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool _morningDigest = true;
  bool _breakingChanges = false;

  /// Purpose: Build notification preferences UI.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscPageScaffold(
      title: 'Notification Preferences',
      bottomNavigation: const PscBottomNav(currentIndex: 3),
      body: ListView(
        children: [
          PscSurfaceCard(
            emphasize: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PscInfoPill(
                  label: 'Calm Frequency',
                  icon: Icons.notifications_active_outlined,
                ),
                const SizedBox(height: 16),
                Text(
                  'Keep useful alerts without feed anxiety.',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Delivery should feel predictable and light. This screen keeps the brief on schedule while protecting your quiet hours.',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PscStateRowCard(
            label: 'Morning digest (08:00)',
            value: _morningDigest ? 'ON' : 'OFF',
            valueColor: _morningDigest
                ? theme.colorScheme.primary
                : theme.textTheme.labelSmall?.color,
            onTap: () => setState(() => _morningDigest = !_morningDigest),
          ),
          const SizedBox(height: 10),
          PscStateRowCard(
            label: 'Breaking alerts',
            value: _breakingChanges ? 'ON' : 'OFF',
            valueColor: _breakingChanges
                ? theme.colorScheme.primary
                : theme.textTheme.labelSmall?.color,
            onTap: () => setState(() => _breakingChanges = !_breakingChanges),
          ),
          const SizedBox(height: 10),
          const PscStateRowCard(label: 'Quiet hours', value: '22:00 - 07:00'),
          const SizedBox(height: 10),
          PscSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PscSectionTitle('Delivery Guidance'),
                const SizedBox(height: 14),
                const PscBulletLine(
                  label:
                      'Use a single daily brief as the default reading moment.',
                  icon: Icons.schedule_outlined,
                ),
                const SizedBox(height: 8),
                const PscBulletLine(
                  label:
                      'Keep breaking alerts off unless a topic truly requires urgency.',
                  icon: Icons.warning_amber_outlined,
                ),
                const SizedBox(height: 8),
                const PscBulletLine(
                  label:
                      'Quiet hours protect focus and reduce notification fatigue.',
                  icon: Icons.bedtime_outlined,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PscStatusBanner(
            message:
                'Push permission is currently denied on this device. Enable it in system settings if you want alerts to arrive on schedule.',
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: () {
              AppFeedbackMessenger.showInfo(
                context,
                message: AppFeedbackMessage.notificationPermissionRequested,
                event: 'notification_permission_retry_requested',
              );
            },
            child: const Text('Retry Permission'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              AppFeedbackMessenger.showSuccess(
                context,
                message: AppFeedbackMessage.notificationRulesSaved,
                event: 'notification_rules_saved',
                fields: {
                  'morningDigestEnabled': _morningDigest,
                  'breakingAlertsEnabled': _breakingChanges,
                },
              );
            },
            child: const Text('Save Notification Rules'),
          ),
        ],
      ),
    );
  }
}
