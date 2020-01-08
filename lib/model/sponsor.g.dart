// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sponsor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sponsors _$SponsorsFromJson(Map json) {
  return Sponsors(
    total: json['total'] as int,
    skip: json['skip'] as int,
    limit: json['limit'] as int,
    items: (json['items'] as List)
        ?.map((e) => e == null ? null : SponsorFields.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$SponsorsToJson(Sponsors instance) => <String, dynamic>{
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
      'items': instance.items,
    };

SponsorFields _$SponsorFieldsFromJson(Map json) {
  return SponsorFields(
    SystemFields.fromJson(Map<String, dynamic>.from(json['sys'] as Map)),
    Sponsor.fromJson(json['fields'] as Map),
  );
}

Map<String, dynamic> _$SponsorFieldsToJson(SponsorFields instance) =>
    <String, dynamic>{
      'sys': instance.sys.toJson(),
      'fields': instance.fields.toJson(),
    };

Sponsor _$SponsorFromJson(Map json) {
  return Sponsor(
    json['nazwaFirmy'] as String,
    json['logo'] == null
        ? null
        : Asset.fromJson((json['logo'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    json['linkDoStronySponsora'] as String,
    _$enumDecodeNullable(_$SponsorLevelEnumMap, json['poziomSponsoringu']),
  );
}

Map<String, dynamic> _$SponsorToJson(Sponsor instance) => <String, dynamic>{
      'nazwaFirmy': instance.name,
      'logo': instance.logo?.toJson(),
      'linkDoStronySponsora': instance.url,
      'poziomSponsoringu': _$SponsorLevelEnumMap[instance.level],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$SponsorLevelEnumMap = {
  SponsorLevel.platinium: 'platinium',
  SponsorLevel.gold: 'gold',
  SponsorLevel.silver: 'silver',
  SponsorLevel.bronze: 'bronze',
};
