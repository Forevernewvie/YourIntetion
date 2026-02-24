// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DigestImpl _$$DigestImplFromJson(Map<String, dynamic> json) => _$DigestImpl(
  id: json['id'] as String,
  profileId: json['profileId'] as String,
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  qualityScore: (json['qualityScore'] as num).toDouble(),
  items: (json['items'] as List<dynamic>)
      .map((e) => DigestItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$DigestImplToJson(_$DigestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileId': instance.profileId,
      'generatedAt': instance.generatedAt.toIso8601String(),
      'qualityScore': instance.qualityScore,
      'items': instance.items,
    };
