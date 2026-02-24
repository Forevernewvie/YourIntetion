import 'package:freezed_annotation/freezed_annotation.dart';

part 'citation.freezed.dart';
part 'citation.g.dart';

/// Purpose: Represent a traceable source citation for a digest item.
@freezed
class Citation with _$Citation {
  /// Purpose: Construct an immutable citation.
  const factory Citation({
    required String id,
    required String sourceName,
    required Uri canonicalUrl,
    required DateTime publishedAt,
  }) = _Citation;

  /// Purpose: Deserialize a citation from JSON.
  factory Citation.fromJson(Map<String, dynamic> json) =>
      _$CitationFromJson(json);
}
