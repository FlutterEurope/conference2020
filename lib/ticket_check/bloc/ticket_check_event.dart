import 'package:conferenceapp/model/ticket.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TicketCheckEvent {}

class InitEvent extends TicketCheckEvent {}

class TicketScanned extends TicketCheckEvent {
  final String valueRead;

  TicketScanned(this.valueRead);
}

class TickedValidated extends TicketCheckEvent {
  final String userId;
  final Ticket ticket;

  TickedValidated(this.userId, this.ticket);
}
