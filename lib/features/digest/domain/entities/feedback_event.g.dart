// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedbackEventImpl _$$FeedbackEventImplFromJson(Map<String, dynamic> json) =>
    _$FeedbackEventImpl(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      rating: (json['rating'] as num).toInt(),
      reason: json['reason'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$FeedbackEventImplToJson(_$FeedbackEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'rating': instance.rating,
      'reason': instance.reason,
      'createdAt': instance.createdAt.toIso8601String(),
    };
