import 'package:flutter/material.dart';

/// Purpose: Provide a compact search field matching Pencil screen style.
class PscSearchField extends StatelessWidget {
  /// Purpose: Construct search field with optional callback.
  const PscSearchField({this.hintText, this.onChanged, super.key});

  final String? hintText;
  final ValueChanged<String>? onChanged;

  /// Purpose: Build search field UI.
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hintText ?? 'Search topics or sources',
        prefixIcon: const Icon(Icons.search, size: 16),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}
