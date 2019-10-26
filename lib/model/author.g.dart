// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map json) {
  return Author(
    json['firstName'] as String,
    json['lastName'] as String,
    json['bio'] as String,
    json['occupation'] as String,
    json['twitter'] as String,
    json['email'] as String,
    json['avatar'] as String,
    json['id'] as int,
  );
}

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'bio': instance.bio,
      'occupation': instance.occupation,
      'twitter': instance.twitter,
      'email': instance.email,
      'avatar': instance.avatar,
      'id': instance.id,
    };
