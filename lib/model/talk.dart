import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/utils/firestore_utils.dart';
import 'package:json_annotation/json_annotation.dart';

import 'author.dart';
import 'room.dart';

part 'talk.g.dart';

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class Talk {
  final String title;
  final List<Author> authors;

  @JsonKey(fromJson: FirestoreUtils.fromJson, toJson: FirestoreUtils.toJson)
  final DateTime dateTime;

  @JsonKey(fromJson: durationFromJson, toJson: toDurationJson)
  final Duration duration;
  final Room room;
  final int level;

  Talk(this.title, this.authors, this.dateTime, this.duration, this.room, this.level);
  factory Talk.fromJson(Map<String, dynamic> json) => _$TalkFromJson(json);
  Map<String, dynamic> toJson() => _$TalkToJson(this);

  static Duration durationFromJson(int duration) {
    return Duration(minutes: duration);
  }

  static int toDurationJson(Duration duration) {
    return duration.inMinutes;
  }
}
