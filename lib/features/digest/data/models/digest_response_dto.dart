import 'package:freezed_annotation/freezed_annotation.dart';

part 'digest_response_dto.freezed.dart';
part 'digest_response_dto.g.dart';

/// Purpose: Transport model for digest payload from API.
@freezed
class DigestResponseDto with _$DigestResponseDto {
  /// Purpose: Construct immutable digest response dto.
  const factory DigestResponseDto({
    required String id,
    required String profileId,
    required DateTime generatedAt,
    required double qualityScore,
    required List<DigestItemDto> items,
  }) = _DigestResponseDto;

  /// Purpose: Deserialize digest response dto from JSON.
  factory DigestResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DigestResponseDtoFromJson(json);
}

/// Purpose: Transport model for digest item in API payload.
@freezed
class DigestItemDto with _$DigestItemDto {
  /// Purpose: Construct immutable digest item dto.
  const factory DigestItemDto({
    required String id,
    required String topic,
    required String whyReason,
    required String summary,
    required int freshnessMinutes,
    required List<CitationDto> citations,
  }) = _DigestItemDto;

  /// Purpose: Deserialize digest item dto from JSON.
  factory DigestItemDto.fromJson(Map<String, dynamic> json) =>
      _$DigestItemDtoFromJson(json);
}

/// Purpose: Transport model for citation in API payload.
@freezed
class CitationDto with _$CitationDto {
  /// Purpose: Construct immutable citation dto.
  const factory CitationDto({
    required String id,
    required String sourceName,
    required Uri canonicalUrl,
    required DateTime publishedAt,
  }) = _CitationDto;

  /// Purpose: Deserialize citation dto from JSON.
  factory CitationDto.fromJson(Map<String, dynamic> json) =>
      _$CitationDtoFromJson(json);
}
