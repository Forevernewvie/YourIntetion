import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';

/// Purpose: Provide custom bottom navigation aligned with the editorial design language.
class PscBottomNav extends StatelessWidget {
  /// Purpose: Construct bottom navigation with current selected index.
  const PscBottomNav({required this.currentIndex, super.key});

  final int currentIndex;

  static const _labels = ['Home', 'Rules', 'Saved', 'Settings'];
  static const _icons = [
    Icons.home_outlined,
    Icons.tune_outlined,
    Icons.bookmark_outline_rounded,
    Icons.settings_outlined,
  ];

  /// Purpose: Build custom pill-based tab bar.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.7)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_labels.length, (index) {
            final selected = index == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => _onSelect(context, index),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? theme.colorScheme.primary.withValues(alpha: 0.14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _icons[index],
                        size: 20,
                        color: selected
                            ? theme.colorScheme.primary
                            : theme.textTheme.labelSmall?.color,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _labels[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: selected
                              ? theme.colorScheme.primary
                              : theme.textTheme.labelSmall?.color,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// Purpose: Navigate to primary route by selected tab index.
  void _onSelect(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutePath.home);
        return;
      case 1:
        context.go(AppRoutePath.rulesBasic);
        return;
      case 2:
        context.go(AppRoutePath.saved);
        return;
      case 3:
        context.go(AppRoutePath.settings);
        return;
    }
  }
}
