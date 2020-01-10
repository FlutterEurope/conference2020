// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) {
  return User(
    json['userId'] as String,
    (json['favoriteTalksIds'] as List).map((e) => e as String).toList(),
    json['ticketId'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'favoriteTalksIds': instance.favoriteTalksIds,
      'userId': instance.userId,
      'ticketId': instance.ticketId,
    };
