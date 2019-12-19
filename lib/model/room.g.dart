// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map json) {
  return Room(
    json['name'] as String,
    json['id'] as String,
  );
}

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
    };
