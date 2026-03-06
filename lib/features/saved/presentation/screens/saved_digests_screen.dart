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
      title: 'Saved Library',
      bottomNavigation: const PscBottomNav(currentIndex: 2),
      body: digestAsync.when(
        data: (digest) {
          return ListView(
            children: [
              _SavedLibraryHero(hasItems: digest.items.isNotEmpty),
              const SizedBox(height: 16),
              const PscSearchField(
                hintText: 'Search saved briefs or collections',
              ),
              const SizedBox(height: 16),
              if (digest.items.isNotEmpty) ...[
                const PscSectionTitle('Recently Saved'),
                const SizedBox(height: 10),
                DigestCardTile(item: digest.items.first, onTap: () {}),
                const SizedBox(height: 16),
              ],
              const PscSectionTitle('Collections'),
              const SizedBox(height: 10),
              const PscRuleSectionCard(
                title: 'Strategy Signals',
                description:
                    'Pinned reading list for roadmap, positioning, and market shifts.',
                status: '8 briefs',
                hint: 'Updated 2d ago',
              ),
              const SizedBox(height: 10),
              const PscRuleSectionCard(
                title: 'Worth Revisiting',
                description:
                    'Longer reads and source-dense items that deserve a second pass.',
                status: '5 briefs',
                hint: 'Designed for deep review',
              ),
              const SizedBox(height: 10),
              _SavedEmptyState(
                title: digest.items.isEmpty
                    ? 'Your archive is still empty.'
                    : 'No other saved items yet.',
                description: digest.items.isEmpty
                    ? 'When a digest earns a second read, save it here so it becomes part of your long-term library.'
                    : 'Save more briefs from detail to build reusable collections.',
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

/// Purpose: Render the archive hero for the saved library screen.
class _SavedLibraryHero extends StatelessWidget {
  /// Purpose: Construct saved library hero.
  const _SavedLibraryHero({required this.hasItems});

  final bool hasItems;

  /// Purpose: Build saved library hero.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PscSurfaceCard(
      emphasize: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PscInfoPill(
            label: 'Editorial Archive',
            icon: Icons.collections_bookmark_outlined,
          ),
          const SizedBox(height: 16),
          Text(
            'Keep the briefs worth returning to.',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Saved items turn a fast-moving digest into a durable research shelf. Pin collections, revisit dense source bundles, and keep important context nearby.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PscInfoPill(
                label: hasItems
                    ? 'Library has active items'
                    : 'Ready for first save',
                icon: Icons.bookmark_outline_rounded,
                backgroundColor: theme.colorScheme.secondary.withValues(
                  alpha: 0.18,
                ),
                foregroundColor: theme.colorScheme.onSurface,
              ),
              PscInfoPill(
                label: 'Collections support deep review',
                icon: Icons.menu_book_outlined,
                backgroundColor: theme.colorScheme.tertiary.withValues(
                  alpha: 0.1,
                ),
                foregroundColor: theme.colorScheme.tertiary,
              ),
            ],
          ),
        ],
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
    return PscSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PscInfoPill(
            label: 'Archive Reminder',
            icon: Icons.inbox_outlined,
          ),
          const SizedBox(height: 16),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(description, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
