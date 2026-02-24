import 'package:freezed_annotation/freezed_annotation.dart';

import 'citation.dart';

part 'digest_item.freezed.dart';
part 'digest_item.g.dart';

/// Purpose: Represent one summarized item in a digest.
@freezed
class DigestItem with _$DigestItem {
  /// Purpose: Construct an immutable digest item.
  const factory DigestItem({
    required String id,
    required String topic,
    required String whyReason,
    required String summary,
    required int freshnessMinutes,
    required List<Citation> citations,
  }) = _DigestItem;

  /// Purpose: Deserialize a digest item from JSON.
  factory DigestItem.fromJson(Map<String, dynamic> json) =>
      _$DigestItemFromJson(json);
}
