// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotification _$NotificationFromJson(Map json) {
  return AppNotification(
    json['title'] as String,
    json['dateTime'] == null
        ? null
        : DateTime.parse(json['dateTime'] as String),
    json['content'] as String,
    json['important'] as bool,
  );
}

Map<String, dynamic> _$NotificationToJson(AppNotification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'dateTime': instance.dateTime?.toIso8601String(),
      'content': instance.content,
      'important': instance.important,
    };
