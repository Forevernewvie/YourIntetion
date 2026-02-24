import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/digest/presentation/providers/digest_providers.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/digest_card_tile.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_bottom_nav.dart';
import '../../../../shared/widgets/psc_search_field.dart';

/// Purpose: Render saved digests and collection placeholders.
class SavedDigestsScreen extends ConsumerWidget {
  /// Purpose: Create saved digests screen widget.
  const SavedDigestsScreen({super.key});

  /// Purpose: Build saved digests view with fallback empty-state card.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final digestAsync = ref.watch(latestDigestProvider);

    return PscPageScaffold(
      title: 'Saved Digests',
      bottomNavigation: const PscBottomNav(currentIndex: 2),
      body: digestAsync.when(
        data: (digest) {
          return ListView(
            children: [
              const PscSearchField(hintText: 'Search saved digests'),
              const SizedBox(height: 10),
              if (digest.items.isNotEmpty) ...[
                DigestCardTile(item: digest.items.first, onTap: () {}),
                const SizedBox(height: 8),
              ],
              const PscRuleSectionCard(
                title: 'Collection: Strategy Signals',
                description: '8 digests • Updated 2d ago',
                status: 'Pinned',
                hint: 'Tap to open',
              ),
              const SizedBox(height: 8),
              _SavedEmptyState(
                title: digest.items.isEmpty
                    ? 'Nothing yet'
                    : 'No archived videos',
                description: digest.items.isEmpty
                    ? 'Save your first digest to build your library.'
                    : 'Save any digest from detail to build your library.',
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: PscStatusBanner(
            message: 'Unable to load saved digests.',
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}

/// Purpose: Render empty state section in saved digests.
class _SavedEmptyState extends StatelessWidget {
  /// Purpose: Construct empty state with title and description.
  const _SavedEmptyState({required this.title, required this.description});

  final String title;
  final String description;

  /// Purpose: Build compact empty state block.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.secondary,
            child: Icon(
              Icons.inbox,
              size: 18,
              color: theme.textTheme.labelSmall?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
