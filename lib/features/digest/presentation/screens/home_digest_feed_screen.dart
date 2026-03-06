import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../features/digest/domain/entities/digest_item.dart';
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
                _DigestOverviewCard(
                  totalItems: 0,
                  freshestMinutes: 0,
                  totalCitations: 0,
                  topReason:
                      'No brief is ready yet. Refresh to pull your next set.',
                  onOpenLead: () =>
                      ref.read(digestRefreshTickProvider.notifier).state++,
                ),
                const SizedBox(height: 16),
                const PscSearchField(hintText: 'Search topics or sources'),
                const SizedBox(height: 16),
                _EmptyDigestState(
                  onRetry: () =>
                      ref.read(digestRefreshTickProvider.notifier).state++,
                ),
              ],
            );
          }

          final leadItem = digest.items.first;
          final totalCitations = digest.items.fold<int>(
            0,
            (sum, item) => sum + item.citations.length,
          );
          final freshestMinutes = digest.items
              .map((item) => item.freshnessMinutes)
              .reduce((value, element) => value < element ? value : element);

          return ListView(
            children: [
              _DigestOverviewCard(
                totalItems: digest.items.length,
                freshestMinutes: freshestMinutes,
                totalCitations: totalCitations,
                topReason: leadItem.whyReason,
                onOpenLead: () =>
                    context.go(AppRoutePath.digestDetailById(digest.id)),
              ),
              const SizedBox(height: 16),
              const PscSearchField(
                hintText: 'Search a topic, source, or brief',
              ),
              const SizedBox(height: 18),
              const PscSectionTitle('Lead Brief'),
              const SizedBox(height: 10),
              _LeadDigestCard(
                item: leadItem,
                onOpen: () =>
                    context.go(AppRoutePath.digestDetailById(digest.id)),
              ),
              if (digest.items.length > 1) ...[
                const SizedBox(height: 18),
                const PscSectionTitle('More Because Of Your Rules'),
                const SizedBox(height: 10),
                ...digest.items.skip(1).map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: DigestCardTile(
                      item: item,
                      onTap: () =>
                          context.go(AppRoutePath.digestDetailById(digest.id)),
                    ),
                  );
                }),
              ],
              const SizedBox(height: 6),
              OutlinedButton(
                onPressed: () =>
                    ref.read(digestRefreshTickProvider.notifier).state++,
                child: const Text('Refresh Brief'),
              ),
            ],
          );
        },
        loading: () => const _LoadingOnlyState(),
        error: (error, stackTrace) => ListView(
          children: [
            const SizedBox(height: 12),
            PscStatusBanner(
              message:
                  'Failed to load your digest. Refresh to pull a new brief.',
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

/// Purpose: Render digest overview hero that frames why the feed matters today.
class _DigestOverviewCard extends StatelessWidget {
  /// Purpose: Construct digest overview hero.
  const _DigestOverviewCard({
    required this.totalItems,
    required this.freshestMinutes,
    required this.totalCitations,
    required this.topReason,
    required this.onOpenLead,
  });

  final int totalItems;
  final int freshestMinutes;
  final int totalCitations;
  final String topReason;
  final VoidCallback onOpenLead;

  /// Purpose: Build digest overview hero.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscSurfaceCard(
      emphasize: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const PscInfoPill(
                label: 'Personalized Brief',
                icon: Icons.auto_awesome_outlined,
              ),
              PscInfoPill(
                label: '$totalItems ranked items',
                icon: Icons.view_agenda_outlined,
                backgroundColor: theme.colorScheme.secondary.withValues(
                  alpha: 0.18,
                ),
                foregroundColor: theme.colorScheme.onSurface,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Your calm read is ready.',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Today\'s lead signals come with traceable sources and explicit rule matches so you can skim fast without losing context.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PscInfoPill(
                label: totalItems == 0
                    ? 'Waiting for items'
                    : '$freshestMinutes min freshness',
                icon: Icons.schedule_outlined,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.1,
                ),
                foregroundColor: theme.colorScheme.primary,
              ),
              PscInfoPill(
                label: '$totalCitations citations',
                icon: Icons.link_outlined,
                backgroundColor: theme.colorScheme.tertiary.withValues(
                  alpha: 0.1,
                ),
                foregroundColor: theme.colorScheme.tertiary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Lead reason',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(topReason, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: onOpenLead,
            child: Text(
              totalItems == 0 ? 'Refresh My Brief' : 'Open Lead Brief',
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go(AppRoutePath.rulesBasic),
            child: const Text('Tune My Rules'),
          ),
        ],
      ),
    );
  }
}

/// Purpose: Render the featured digest card with stronger hierarchy than list tiles.
class _LeadDigestCard extends StatelessWidget {
  /// Purpose: Construct lead digest card.
  const _LeadDigestCard({required this.item, required this.onOpen});

  final DigestItem item;
  final VoidCallback onOpen;

  /// Purpose: Build featured digest card.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PscSurfaceCard(
      onTap: onOpen,
      emphasize: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PscInfoPill(
                label: 'Open now',
                icon: Icons.arrow_forward_rounded,
                backgroundColor: theme.colorScheme.tertiary.withValues(
                  alpha: 0.12,
                ),
                foregroundColor: theme.colorScheme.tertiary,
              ),
              const Spacer(),
              Text(
                '${item.freshnessMinutes}m ago',
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(item.topic, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 10),
          Text(item.summary, style: theme.textTheme.bodyLarge),
          const SizedBox(height: 14),
          Text(
            item.whyReason,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${item.citations.length} traceable sources attached',
                  style: theme.textTheme.labelMedium,
                ),
              ),
              Icon(
                Icons.arrow_outward_rounded,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ],
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
    return PscSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PscInfoPill(
            label: 'No Brief Yet',
            icon: Icons.hourglass_empty_rounded,
          ),
          const SizedBox(height: 16),
          Text(
            'Your next digest is still forming.',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Adjust your rule preferences or pull again in a few minutes to surface a fresh set of explainable items.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
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
    return PscSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 110,
            height: 30,
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 18),
          _SkeletonBar(width: 240, height: 26),
          const SizedBox(height: 10),
          _SkeletonBar(width: double.infinity),
          const SizedBox(height: 8),
          _SkeletonBar(width: 260),
          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(child: _SkeletonBar(width: double.infinity, height: 36)),
              SizedBox(width: 8),
              Expanded(child: _SkeletonBar(width: double.infinity, height: 36)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Purpose: Render one horizontal skeleton placeholder.
class _SkeletonBar extends StatelessWidget {
  /// Purpose: Construct skeleton bar with fixed width.
  const _SkeletonBar({required this.width, this.height = 10});

  final double width;
  final double height;

  /// Purpose: Build one skeleton line.
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.45),
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
        _LoadingSkeletonCard(),
        SizedBox(height: 16),
        PscSearchField(hintText: 'Search topics or sources'),
        SizedBox(height: 16),
        _LoadingSkeletonCard(),
      ],
    );
  }
}
