import 'package:freezed_annotation/freezed_annotation.dart';

import 'citation.dart';

part 'source_item.freezed.dart';
part 'source_item.g.dart';

/// Purpose: Represent normalized source content before summarization.
@freezed
class SourceItem with _$SourceItem {
  /// Purpose: Construct an immutable normalized source item.
  const factory SourceItem({
    required String id,
    required String topic,
    required String category,
    required String sourceDomain,
    required String title,
    required String body,
    required DateTime publishedAt,
    required List<Citation> citations,
  }) = _SourceItem;

  /// Purpose: Deserialize a source item from JSON.
  factory SourceItem.fromJson(Map<String, dynamic> json) =>
      _$SourceItemFromJson(json);
}
