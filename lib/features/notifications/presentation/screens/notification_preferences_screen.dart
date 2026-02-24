import 'package:flutter/material.dart';

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
          const Text('Control frequency without reintroducing feed anxiety.'),
          const SizedBox(height: 12),
          PscStateRowCard(
            label: 'Morning digest (08:00)',
            value: _morningDigest ? 'ON' : 'OFF',
            valueColor: _morningDigest
                ? const Color(0xFF1B8F5A)
                : theme.textTheme.labelSmall?.color,
            onTap: () => setState(() => _morningDigest = !_morningDigest),
          ),
          const SizedBox(height: 8),
          PscStateRowCard(
            label: 'Breaking alerts',
            value: _breakingChanges ? 'ON' : 'OFF',
            valueColor: _breakingChanges
                ? const Color(0xFF1B8F5A)
                : theme.textTheme.labelSmall?.color,
            onTap: () => setState(() => _breakingChanges = !_breakingChanges),
          ),
          const SizedBox(height: 8),
          const PscStateRowCard(label: 'Quiet hours', value: '22:00 - 07:00'),
          const SizedBox(height: 8),
          PscStatusBanner(
            message: 'Push permission denied on device. Enable in OS settings.',
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Permission check requested.')),
              );
            },
            child: const Text('Retry Permission'),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification rules saved.')),
              );
            },
            child: const Text('Save Notification Rules'),
          ),
        ],
      ),
    );
  }
}
