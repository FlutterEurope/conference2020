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
    _$enumDecode(_$TalkTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$TalkToJson(Talk instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'authors': instance.authors.map((e) => e.toJson()).toList(),
      'description': instance.description,
      'type': _$TalkTypeEnumMap[instance.type],
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'room': instance.room.toJson(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

const _$TalkTypeEnumMap = {
  TalkType.beginner: 'beginner',
  TalkType.advanced: 'advanced',
  TalkType.other: 'other',
};
