import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Purpose: Provide custom bottom navigation aligned with Pencil design language.
class PscBottomNav extends StatelessWidget {
  /// Purpose: Construct bottom navigation with current selected index.
  const PscBottomNav({required this.currentIndex, super.key});

  final int currentIndex;

  static const _labels = ['Home', 'Rules', 'Saved', 'Settings'];

  /// Purpose: Build custom pill-based tab bar.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: List.generate(_labels.length, (index) {
            final selected = index == currentIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => _onSelect(context, index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: selected
                        ? theme.colorScheme.secondary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _labels[index],
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? theme.colorScheme.onSecondary
                          : theme.textTheme.labelSmall?.color,
                    ),
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
        context.go('/home');
      case 1:
        context.go('/rules/basic');
      case 2:
        context.go('/saved');
      case 3:
        context.go('/settings');
    }
  }
}
