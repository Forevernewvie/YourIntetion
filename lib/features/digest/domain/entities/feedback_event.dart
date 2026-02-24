import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_event.freezed.dart';
part 'feedback_event.g.dart';

/// Purpose: Represent user feedback used for digest tuning.
@freezed
class FeedbackEvent with _$FeedbackEvent {
  /// Purpose: Construct an immutable feedback event.
  const factory FeedbackEvent({
    required String id,
    required String itemId,
    required int rating,
    required String reason,
    required DateTime createdAt,
  }) = _FeedbackEvent;

  /// Purpose: Deserialize a feedback event from JSON.
  factory FeedbackEvent.fromJson(Map<String, dynamic> json) =>
      _$FeedbackEventFromJson(json);
}
