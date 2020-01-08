import 'package:conferenceapp/model/agenda.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:conferenceapp/utils/contentful_helper.dart';

part 'author.g.dart';

@JsonSerializable(
  nullable: false,
  ignoreUnannotated: false,
  anyMap: true,
)
class Author {
  Author(
    this.id,
    this.name,
    this.longBio,
    this.occupation,
    this.twitter,
    this.avatar,
  );

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorToJson(this);

  factory Author.fromSpeaker(ContentfulSpeaker speaker) {
    if (speaker == null) {
      return null;
    }
    return Author(
      speaker.sys?.id,
      speaker.fields.name,
      speaker.fields.longBio.toSimpleString(),
      speaker.fields.bio.toSimpleString(),
      speaker.fields.twitter,
      speaker.fields.picture.fields.file.url.replaceAll("//", "http://"),
    );
  }

  final String id;
  final String name;
  final String longBio;
  final String occupation;
  final String twitter;
  final String avatar;

  @override
  String toString() {
    return name;
  }
}
