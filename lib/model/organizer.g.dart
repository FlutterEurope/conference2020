// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organizers _$OrganizersFromJson(Map json) {
  return Organizers(
    total: json['total'] as int,
    skip: json['skip'] as int,
    limit: json['limit'] as int,
    items: (json['items'] as List)
        ?.map((e) => e == null ? null : OrganizerFields.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$OrganizersToJson(Organizers instance) =>
    <String, dynamic>{
      'total': instance.total,
      'skip': instance.skip,
      'limit': instance.limit,
      'items': instance.items,
    };

OrganizerFields _$OrganizerFieldsFromJson(Map json) {
  return OrganizerFields(
    SystemFields.fromJson(Map<String, dynamic>.from(json['sys'] as Map)),
    Organizer.fromJson(json['fields'] as Map),
  );
}

Map<String, dynamic> _$OrganizerFieldsToJson(OrganizerFields instance) =>
    <String, dynamic>{
      'sys': instance.sys.toJson(),
      'fields': instance.fields.toJson(),
    };

Organizer _$OrganizerFromJson(Map json) {
  return Organizer(
    json['name'] as String,
    Asset.fromJson(Map<String, dynamic>.from(json['picture'] as Map)),
    _storeDocumentAsString(json['bio'] as Map),
    _storeDocumentAsString(json['longBio'] as Map),
    json['order'] as int,
  );
}

Map<String, dynamic> _$OrganizerToJson(Organizer instance) => <String, dynamic>{
      'name': instance.name,
      'picture': instance.picture.toJson(),
      'bio': instance.bio,
      'longBio': instance.longBio,
      'order': instance.order,
    };
