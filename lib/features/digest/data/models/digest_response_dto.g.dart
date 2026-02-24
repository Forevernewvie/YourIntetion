// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digest_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DigestResponseDtoImpl _$$DigestResponseDtoImplFromJson(
  Map<String, dynamic> json,
) => _$DigestResponseDtoImpl(
  id: json['id'] as String,
  profileId: json['profileId'] as String,
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  qualityScore: (json['qualityScore'] as num).toDouble(),
  items: (json['items'] as List<dynamic>)
      .map((e) => DigestItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$DigestResponseDtoImplToJson(
  _$DigestResponseDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'profileId': instance.profileId,
  'generatedAt': instance.generatedAt.toIso8601String(),
  'qualityScore': instance.qualityScore,
  'items': instance.items,
};

_$DigestItemDtoImpl _$$DigestItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$DigestItemDtoImpl(
      id: json['id'] as String,
      topic: json['topic'] as String,
      whyReason: json['whyReason'] as String,
      summary: json['summary'] as String,
      freshnessMinutes: (json['freshnessMinutes'] as num).toInt(),
      citations: (json['citations'] as List<dynamic>)
          .map((e) => CitationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DigestItemDtoImplToJson(_$DigestItemDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'whyReason': instance.whyReason,
      'summary': instance.summary,
      'freshnessMinutes': instance.freshnessMinutes,
      'citations': instance.citations,
    };

_$CitationDtoImpl _$$CitationDtoImplFromJson(Map<String, dynamic> json) =>
    _$CitationDtoImpl(
      id: json['id'] as String,
      sourceName: json['sourceName'] as String,
      canonicalUrl: Uri.parse(json['canonicalUrl'] as String),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );

Map<String, dynamic> _$$CitationDtoImplToJson(_$CitationDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceName': instance.sourceName,
      'canonicalUrl': instance.canonicalUrl.toString(),
      'publishedAt': instance.publishedAt.toIso8601String(),
    };
