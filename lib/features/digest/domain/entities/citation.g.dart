// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'citation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CitationImpl _$$CitationImplFromJson(Map<String, dynamic> json) =>
    _$CitationImpl(
      id: json['id'] as String,
      sourceName: json['sourceName'] as String,
      canonicalUrl: Uri.parse(json['canonicalUrl'] as String),
      publishedAt: DateTime.parse(json['publishedAt'] as String),
    );

Map<String, dynamic> _$$CitationImplToJson(_$CitationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceName': instance.sourceName,
      'canonicalUrl': instance.canonicalUrl.toString(),
      'publishedAt': instance.publishedAt.toIso8601String(),
    };
