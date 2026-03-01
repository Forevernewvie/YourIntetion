import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/layout/psc_page_scaffold.dart';
import '../../../../shared/widgets/digest_card_tile.dart';
import '../../../../shared/widgets/psc_blocks.dart';
import '../../../../shared/widgets/psc_bottom_nav.dart';
import '../../../../shared/widgets/psc_search_field.dart';
import '../providers/digest_providers.dart';

/// Purpose: Render latest digest feed with explainability and citation metadata.
class HomeDigestFeedScreen extends ConsumerWidget {
  /// Purpose: Create home digest feed screen widget.
  const HomeDigestFeedScreen({super.key});

  /// Purpose: Build feed screen state from Riverpod async digest provider.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final digestAsync = ref.watch(latestDigestProvider);

    return PscPageScaffold(
      title: 'Your Digest',
      bottomNavigation: const PscBottomNav(currentIndex: 0),
      body: digestAsync.when(
        data: (digest) {
          final hasItems = digest.items.isNotEmpty;
          if (!hasItems) {
            return ListView(
              children: [
                const PscSearchField(hintText: 'Search topics or sources'),
                const SizedBox(height: 10),
                _EmptyDigestState(
                  onRetry: () =>
                      ref.read(digestRefreshTickProvider.notifier).state++,
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () =>
                      ref.read(digestRefreshTickProvider.notifier).state++,
                  child: const Text('Retry Refresh'),
                ),
              ],
            );
          }

          return Column(
            children: [
              const PscSearchField(hintText: 'Search topics or sources'),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: digest.items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = digest.items[index];
                    return DigestCardTile(
                      item: item,
                      onTap: () =>
                          context.go(AppRoutePath.digestDetailById(digest.id)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () =>
                    ref.read(digestRefreshTickProvider.notifier).state++,
                child: const Text('Retry Refresh'),
              ),
            ],
          );
        },
        loading: () => const _LoadingOnlyState(),
        error: (error, stackTrace) => ListView(
          children: [
            const SizedBox(height: 12),
            PscStatusBanner(
              message: 'Failed to load latest digest. Try again.',
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  ref.read(digestRefreshTickProvider.notifier).state++,
              child: const Text('Retry Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Purpose: Render empty state when backend returns no digest items.
class _EmptyDigestState extends StatelessWidget {
  /// Purpose: Construct empty digest state widget.
  const _EmptyDigestState({required this.onRetry});

  final VoidCallback onRetry;

  /// Purpose: Build user guidance for no-content digest state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No digest items yet.',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting rule preferences or refresh later.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Retry Now')),
        ],
      ),
    );
  }
}

/// Purpose: Render compact loading skeleton block for digest list.
class _LoadingSkeletonCard extends StatelessWidget {
  /// Purpose: Create loading skeleton card widget.
  const _LoadingSkeletonCard();

  /// Purpose: Build non-animated skeleton placeholders.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBar(width: 220),
          const SizedBox(height: 8),
          _SkeletonBar(width: 320),
          const SizedBox(height: 8),
          _SkeletonBar(width: 280),
        ],
      ),
    );
  }
}

/// Purpose: Render one horizontal skeleton placeholder.
class _SkeletonBar extends StatelessWidget {
  /// Purpose: Construct skeleton bar with fixed width.
  const _SkeletonBar({required this.width});

  final double width;

  /// Purpose: Build one skeleton line.
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

/// Purpose: Render loading-only state while digest provider resolves.
class _LoadingOnlyState extends StatelessWidget {
  /// Purpose: Create loading state widget.
  const _LoadingOnlyState();

  /// Purpose: Build loading state with search and skeleton.
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        PscSearchField(hintText: 'Search topics or sources'),
        SizedBox(height: 10),
        _LoadingSkeletonCard(),
      ],
    );
  }
}
