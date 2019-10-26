import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/utils/firestore_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'talk_list.g.dart';

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class TalkList {
  @JsonKey(fromJson: FirestoreUtils.fromJson, toJson: FirestoreUtils.toJson)
  final DateTime day;
  final List<Talk> talks;

  TalkList(this.day, this.talks);
  factory TalkList.fromJson(Map<String, dynamic> json) => _$TalkListFromJson(json);
  Map<String, dynamic> toJson() => _$TalkListToJson(this);
}
