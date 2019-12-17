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
    FirestoreUtils.fromJson(json['startTime'] as Timestamp),
    FirestoreUtils.fromJson(json['endTime'] as Timestamp),
    Room.fromJson(Map<String, dynamic>.from(json['room'] as Map)),
  );
}

Map<String, dynamic> _$TalkToJson(Talk instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authors': instance.authors.map((e) => e.toJson()).toList(),
      'startTime': FirestoreUtils.toJson(instance.startTime),
      'endTime': FirestoreUtils.toJson(instance.endTime),
      'room': instance.room.toJson(),
    };
