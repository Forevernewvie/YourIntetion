import 'package:freezed_annotation/freezed_annotation.dart';

import 'digest_item.dart';

part 'digest.freezed.dart';
part 'digest.g.dart';

/// Purpose: Represent a generated digest and its included items.
@freezed
class Digest with _$Digest {
  /// Purpose: Construct an immutable digest aggregate.
  const factory Digest({
    required String id,
    required String profileId,
    required DateTime generatedAt,
    required double qualityScore,
    required List<DigestItem> items,
  }) = _Digest;

  /// Purpose: Deserialize a digest from JSON.
  factory Digest.fromJson(Map<String, dynamic> json) => _$DigestFromJson(json);
}
