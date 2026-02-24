// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digest_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DigestItemImpl _$$DigestItemImplFromJson(Map<String, dynamic> json) =>
    _$DigestItemImpl(
      id: json['id'] as String,
      topic: json['topic'] as String,
      whyReason: json['whyReason'] as String,
      summary: json['summary'] as String,
      freshnessMinutes: (json['freshnessMinutes'] as num).toInt(),
      citations: (json['citations'] as List<dynamic>)
          .map((e) => Citation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DigestItemImplToJson(_$DigestItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'whyReason': instance.whyReason,
      'summary': instance.summary,
      'freshnessMinutes': instance.freshnessMinutes,
      'citations': instance.citations,
    };
