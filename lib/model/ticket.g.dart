// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map json) {
  return Ticket(
    json['orderId'] as String,
    json['ticketId'] as String,
  );
}

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'orderId': instance.orderId,
      'ticketId': instance.ticketId,
    };
