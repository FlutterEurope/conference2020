// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map json) {
  return Room(
    json['name'] as String,
    json['capacity'] as int,
    json['id'] as int,
  );
}

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'name': instance.name,
      'capacity': instance.capacity,
      'id': instance.id,
    };
