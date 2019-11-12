// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map json) {
  return Ticket(
    json['orderId'] as String,
    json['ticketId'] as String,
    json['email'] as String,
    _$enumDecode(_$TicketTypeEnumMap, json['type']),
  );
}

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'ticketId': instance.ticketId,
      'email': instance.email,
      'type': _$TicketTypeEnumMap[instance.type],
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

const _$TicketTypeEnumMap = {
  TicketType.Blind: 'Blind',
  TicketType.EarlyBird: 'EarlyBird',
  TicketType.Regular: 'Regular',
  TicketType.LateForTheParty: 'LateForTheParty',
  TicketType.Student: 'Student',
};
