// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map json) {
  return Author(
    json['id'] as String,
    json['name'] as String,
    json['longBio'] as String,
    json['occupation'] as String,
    json['twitter'] as String,
    json['avatar'] as String,
  );
}

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'longBio': instance.longBio,
      'occupation': instance.occupation,
      'twitter': instance.twitter,
      'avatar': instance.avatar,
    };
