import 'package:contentful/contentful.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sponsor.g.dart';

@JsonSerializable()
class Sponsors extends EntryCollection<SponsorFields> {
  Sponsors({
    int total,
    int skip,
    int limit,
    List<SponsorFields> items,
  }) : super(
          total: total,
          skip: skip,
          limit: limit,
          items: items,
        );

  static Sponsors fromJson(Map<String, dynamic> json) =>
      _$SponsorsFromJson(json);
  Map<String, dynamic> toJson() => _$SponsorsToJson(this);
}

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class SponsorFields extends Entry<Sponsor> {
  SponsorFields(SystemFields sys, Sponsor fields)
      : super(fields: fields, sys: sys);

  static SponsorFields fromJson(Map<String, dynamic> json) =>
      _$SponsorFieldsFromJson(json);
  Map<String, dynamic> toJson() => _$SponsorFieldsToJson(this);
}

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class Sponsor extends Equatable {
  @JsonKey(name: 'nazwaFirmy', nullable: true)
  final String name;
  @JsonKey(name: 'logo', nullable: true)
  final Asset logo;
  @JsonKey(name: 'linkDoStronySponsora', nullable: true)
  final String url;
  @JsonKey(name: 'poziomSponsoringu', nullable: true)
  final SponsorLevel level;
  @JsonKey(ignore: true)
  String get logoUrl => logo?.fields?.file?.url?.replaceAll("//", "http://");

  Sponsor(this.name, this.logo, this.url, this.level);

  static Sponsor fromJson(Map<String, dynamic> json) => _$SponsorFromJson(json);
  Map<String, dynamic> toJson() => _$SponsorToJson(this);

  @override
  List<Object> get props => [name];
}

enum SponsorLevel {
  platinium,
  gold,
  silver,
  bronze,
}
