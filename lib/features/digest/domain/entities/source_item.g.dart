// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SourceItemImpl _$$SourceItemImplFromJson(Map<String, dynamic> json) =>
    _$SourceItemImpl(
      id: json['id'] as String,
      topic: json['topic'] as String,
      category: json['category'] as String,
      sourceDomain: json['sourceDomain'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      citations: (json['citations'] as List<dynamic>)
          .map((e) => Citation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SourceItemImplToJson(_$SourceItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'category': instance.category,
      'sourceDomain': instance.sourceDomain,
      'title': instance.title,
      'body': instance.body,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'citations': instance.citations,
    };
