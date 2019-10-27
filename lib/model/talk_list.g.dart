// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'talk_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkList _$TalkListFromJson(Map json) {
  return TalkList(
    FirestoreUtils.fromJson(json['day'] as Timestamp),
    (json['talks'] as List)
        .map((e) => Talk.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList(),
  );
}

Map<String, dynamic> _$TalkListToJson(TalkList instance) => <String, dynamic>{
      'day': FirestoreUtils.toJson(instance.day),
      'talks': instance.talks.map((e) => e.toJson()).toList(),
    };
