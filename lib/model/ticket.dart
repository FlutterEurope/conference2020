import 'package:json_annotation/json_annotation.dart';

part 'ticket.g.dart';

@JsonSerializable(
  nullable: false,
  explicitToJson: true,
  anyMap: true,
)
class Ticket {
  Ticket(this.orderId, this.ticketId, this.email, this.type);

  @JsonKey(nullable: true)
  final String orderId;
  @JsonKey(nullable: true)
  final String ticketId;
  @JsonKey(nullable: true)
  final String email;
  final TicketType type;

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);
}

enum TicketType { Blind, EarlyBird, Regular, LateForTheParty, Student }
