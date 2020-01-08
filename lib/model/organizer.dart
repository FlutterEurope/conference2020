import 'dart:convert';

import 'package:contentful/contentful.dart';
import 'package:contentful_rich_text/types/types.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'organizer.g.dart';

@JsonSerializable()
class Organizers extends EntryCollection<OrganizerFields> {
  Organizers({
    int total,
    int skip,
    int limit,
    List<OrganizerFields> items,
  }) : super(
          total: total,
          skip: skip,
          limit: limit,
          items: items,
        );

  static Organizers fromJson(Map<String, dynamic> json) =>
      _$OrganizersFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizersToJson(this);
}

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class OrganizerFields extends Entry<Organizer> {
  OrganizerFields(SystemFields sys, Organizer fields)
      : super(fields: fields, sys: sys);

  static OrganizerFields fromJson(Map<String, dynamic> json) =>
      _$OrganizerFieldsFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizerFieldsToJson(this);
}

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class Organizer extends Equatable implements Comparable<Organizer> {
  final String name;
  final Asset picture;
  String get pictureUrl =>
      picture?.fields?.file?.url?.replaceAll("//", "http://");

  @JsonKey(fromJson: _storeDocumentAsString)
  final String bio;

  Map get bioMap => jsonDecode(bio);

  @JsonKey(fromJson: _storeDocumentAsString)
  final String longBio;

  Map get longBioMap => jsonDecode(longBio);

  Document get longBioDocument => _documentFromJson(jsonDecode(longBio));
  final int order;

  Organizer(this.name, this.picture, this.bio, this.longBio, this.order);

  static Organizer fromJson(Map<String, dynamic> json) =>
      _$OrganizerFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizerToJson(this);

  @override
  List<Object> get props => [name];

  @override
  int compareTo(Organizer other) {
    return order?.compareTo(other?.order) ?? name?.compareTo(other?.name) ?? 0;
  }
}

String _storeDocumentAsString(Map doc) {
  return jsonEncode(doc);
}

String _documentToJson(Document doc) {
  return '''{
"content": ${doc.content},
"data": ${doc.data},
"nodeType": ${doc.nodeType}}
}
''';
}

Document _documentFromJson(Map json) {
  return Document.fromJson(json);
}
