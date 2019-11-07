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
    FirestoreUtils.fromJson(json['dateTime'] as Timestamp),
    Talk.durationFromJson(json['duration'] as int),
    Room.fromJson(Map<String, dynamic>.from(json['room'] as Map)),
    json['level'] as int,
  );
}

Map<String, dynamic> _$TalkToJson(Talk instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authors': instance.authors.map((e) => e.toJson()).toList(),
      'dateTime': FirestoreUtils.toJson(instance.dateTime),
      'duration': Talk.toDurationJson(instance.duration),
      'room': instance.room.toJson(),
      'level': instance.level,
    };
