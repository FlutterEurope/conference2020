// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Agenda _$AgendaFromJson(Map json) {
  return Agenda(
    total: json['total'] as int,
    skip: json['skip'] as int,
    limit: json['limit'] as int,
    items: (json['items'] as List)
        ?.map((e) => e == null ? null : AgendaFields.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$AgendaToJson(Agenda instance) => <String, dynamic>{
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
      'items': instance.items,
    };

AgendaFields _$AgendaFieldsFromJson(Map json) {
  return AgendaFields(
    SystemFields.fromJson(Map<String, dynamic>.from(json['sys'] as Map)),
    Fields.fromJson(json['fields'] as Map),
  );
}

Map<String, dynamic> _$AgendaFieldsToJson(AgendaFields instance) =>
    <String, dynamic>{
      'sys': instance.sys.toJson(),
      'fields': instance.fields.toJson(),
    };

Fields _$FieldsFromJson(Map json) {
  return Fields(
    Fields._dayFromJson(json['day'] as String),
    json['time'] as String,
    json['title'] as String,
    _$enumDecode(_$TalkTypeEnumMap, json['type']),
    json['speaker'] == null
        ? null
        : ContentfulSpeaker.fromJson(json['speaker'] as Map),
    json['secondSpeaked'] == null
        ? null
        : ContentfulSpeaker.fromJson(json['secondSpeaked'] as Map),
    _storeDocumentAsString(json['description'] as Map),
  );
}

Map<String, dynamic> _$FieldsToJson(Fields instance) => <String, dynamic>{
      'day': Fields._dayToJson(instance.day),
      'time': instance.time,
      'title': instance.title,
      'type': _$TalkTypeEnumMap[instance.type],
      'speaker': instance.speaker?.toJson(),
      'secondSpeaked': instance.secondSpeaker?.toJson(),
      'description': instance.description,
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

ContentfulSpeaker _$ContentfulSpeakerFromJson(Map json) {
  return ContentfulSpeaker(
    SystemFields.fromJson(Map<String, dynamic>.from(json['sys'] as Map)),
    ContentfulSpeakerFields.fromJson(json['fields'] as Map),
  );
}

Map<String, dynamic> _$ContentfulSpeakerToJson(ContentfulSpeaker instance) =>
    <String, dynamic>{
      'sys': instance.sys.toJson(),
      'fields': instance.fields.toJson(),
    };

ContentfulSpeakerFields _$ContentfulSpeakerFieldsFromJson(Map json) {
  return ContentfulSpeakerFields(
    json['name'] as String,
    json['twitter'] as String,
    json['picture'] == null
        ? null
        : Asset.fromJson((json['picture'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['topic'] as String,
    _documentFromJson(json['bio'] as Map),
    _documentFromJson(json['longBio'] as Map),
  );
}

Map<String, dynamic> _$ContentfulSpeakerFieldsToJson(
        ContentfulSpeakerFields instance) =>
    <String, dynamic>{
      'name': instance.name,
      'twitter': instance.twitter,
      'picture': instance.picture?.toJson(),
      'topic': instance.topic,
      'bio': _documentToJson(instance.bio),
      'longBio': _documentToJson(instance.longBio),
    };
