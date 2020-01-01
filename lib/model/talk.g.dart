// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Talk _$TalkFromJson(Map json) {
  return Talk(
    json['id'] as String,
    json['title'] as String,
    (json['authors'] as List)
        .map((e) => Author.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
    json['description'] as String,
    DateTime.parse(json['startTime'] as String),
    DateTime.parse(json['endTime'] as String),
    Room.fromJson(Map<String, dynamic>.from(json['room'] as Map)),
  );
}

Map<String, dynamic> _$TalkToJson(Talk instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authors': instance.authors.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'room': instance.room.toJson(),
    };
