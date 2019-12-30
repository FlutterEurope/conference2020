import 'package:json_annotation/json_annotation.dart';

part 'ticket.g.dart';

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class Ticket {
  Ticket(this.orderId, this.ticketId);

  final String orderId;
  final String ticketId;

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
  Map<String, dynamic> toJson() => _$TicketToJson(this);
}