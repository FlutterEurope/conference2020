import 'dart:convert';

import 'package:contentful_rich_text/types/types.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:contentful/contentful.dart';

part 'agenda.g.dart';

enum TalkType { beginner, advanced, other }
enum Day { day_one, day_two }

@JsonSerializable()
class Agenda extends EntryCollection<AgendaFields> {
  Agenda({
    int total,
    int skip,
    int limit,
    List<AgendaFields> items,
  }) : super(
          total: total,
          skip: skip,
          limit: limit,
          items: items,
        );

  static Agenda fromJson(Map<String, dynamic> json) => _$AgendaFromJson(json);
  Map<String, dynamic> toJson() => _$AgendaToJson(this);
}

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class AgendaFields extends Entry<Fields> {
  AgendaFields(SystemFields sys, Fields fields)
      : super(fields: fields, sys: sys);

  static AgendaFields fromJson(Map<String, dynamic> json) =>
      _$AgendaFieldsFromJson(json);
  Map<String, dynamic> toJson() => _$AgendaFieldsToJson(this);
}

String _documentToJson(Document doc) {
  return '''{
"content": ${doc.content},
"data": ${doc.data},
"nodeType": ${doc.nodeType}
}
''';
}

Document _documentFromJson(Map json) {
  return Document.fromJson(json);
}

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class Fields extends Equatable {
  @JsonKey(fromJson: _dayFromJson, toJson: _dayToJson)
  final Day day;
  final String time;
  final String title;
  final TalkType type;
  @JsonKey(nullable: true)
  final ContentfulSpeaker speaker;
  @JsonKey(nullable: true, name: 'secondSpeaked')
  final ContentfulSpeaker secondSpeaker;

  @JsonKey(ignore: true)
  Document get descriptionDocument =>
      _documentFromJson(jsonDecode(description));

  @JsonKey(fromJson: _storeDocumentAsString)
  final String description;

  @JsonKey(ignore: true)
  Map get descriptionMap => jsonDecode(description);

  Fields(this.day, this.time, this.title, this.type, this.speaker,
      this.secondSpeaker, this.description);

  static Fields fromJson(Map<String, dynamic> json) => _$FieldsFromJson(json);
  Map<String, dynamic> toJson() => _$FieldsToJson(this);

  @override
  List<Object> get props => [title, day, time];

  static Day _dayFromJson(String value) {
    if (value == 'day one') {
      return Day.day_one;
    }
    if (value == 'day two') {
      return Day.day_two;
    }
    return null;
  }

  static String _dayToJson(Day day) {
    if (day == Day.day_one) {
      return 'day one';
    }
    if (day == Day.day_two) {
      return 'day two';
    }
    return '';
  }

  @override
  String toString() {
    return '$title';
  }
}

String _storeDocumentAsString(Map doc) {
  return jsonEncode(doc);
}

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class ContentfulSpeaker extends Entry<ContentfulSpeakerFields> {
  ContentfulSpeaker(SystemFields sys, ContentfulSpeakerFields fields)
      : super(sys: sys, fields: fields);

  static ContentfulSpeaker fromJson(Map<String, dynamic> json) =>
      _$ContentfulSpeakerFromJson(json);
  Map<String, dynamic> toJson() => _$ContentfulSpeakerToJson(this);
}

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class ContentfulSpeakerFields extends Equatable {
  final String name;
  @JsonKey(nullable: true)
  final String twitter;
  @JsonKey(nullable: true)
  final Asset picture;
  @JsonKey(nullable: true)
  final String topic;
  @JsonKey(fromJson: _documentFromJson, toJson: _documentToJson)
  final Document bio;
  @JsonKey(fromJson: _documentFromJson, toJson: _documentToJson)
  final Document longBio;

  ContentfulSpeakerFields(this.name, this.twitter, this.picture, this.topic,
      this.bio, this.longBio);

  static ContentfulSpeakerFields fromJson(Map<String, dynamic> json) =>
      _$ContentfulSpeakerFieldsFromJson(json);
  Map<String, dynamic> toJson() => _$ContentfulSpeakerFieldsToJson(this);

  @override
  List<Object> get props => [name, twitter];
}
