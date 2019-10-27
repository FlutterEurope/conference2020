import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@JsonSerializable(
  nullable: false,
  ignoreUnannotated: false,
  anyMap: true,
)
class Author {
  Author(this.firstName, this.lastName, this.bio, this.occupation, this.twitter, this.email, this.avatar, this.id);
  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorToJson(this);

  final String firstName;
  final String lastName;

  @JsonKey(ignore: true)
  String get fullName => "$firstName $lastName";

  final String bio;
  final String occupation;
  final String twitter;
  final String email;
  final String avatar;
  final int id;
}
