import 'dart:convert';

import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/model/agenda.dart';
import 'package:json_annotation/json_annotation.dart';

import 'author.dart';
import 'room.dart';

part 'talk.g.dart';

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class Talk implements Comparable<Talk> {
  final String id;
  final String title;
  final List<Author> authors;
  final String description;
  final TalkType type;

  Map get descriptionMap => jsonDecode(description);

  // @JsonKey(fromJson: FirestoreUtils.fromJson, toJson: FirestoreUtils.toJson)
  final DateTime startTime;
  // @JsonKey(fromJson: FirestoreUtils.fromJson, toJson: FirestoreUtils.toJson)
  final DateTime endTime;
  final Room room;

  Talk(
    this.id,
    this.title,
    this.authors,
    this.description,
    this.startTime,
    this.endTime,
    this.room,
    this.type,
  );

  factory Talk.fromContentful(AgendaFields item) {
    try {
      final authors = [
        Author.fromSpeaker(item.fields?.speaker),
        Author.fromSpeaker(item.fields?.secondSpeaker)
      ]..removeWhere((n) => n == null);

      return Talk(
        item.sys.id,
        item.fields.title,
        authors,
        item.fields.description,
        DateTime(
          2020,
          1,
          item.fields.day == Day.day_one ? 23 : 24,
          int.parse(item.fields.time.substring(0, 2)),
          int.parse(item.fields.time.substring(3, 5)),
        ),
        DateTime(
          2020,
          1,
          item.fields.day == Day.day_one ? 23 : 24,
          int.parse(item.fields.time.substring(6, 8)),
          int.parse(item.fields.time.substring(9, 11)),
        ),
        Room.fromContentfulType(item.fields.type),
        item.fields.type,
      );
    } catch (e, s) {
      logger.errorException(e, s);
    }
    return null;
  }

  factory Talk.fromJson(Map<String, dynamic> json) => _$TalkFromJson(json);

  Map<String, dynamic> toJson() => _$TalkToJson(this);

  @override
  int compareTo(Talk other) {
    return startTime.compareTo(other.startTime);
  }

  @override
  String toString() {
    return "Talk: $title";
  }
}
