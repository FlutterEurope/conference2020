import 'package:conferenceapp/model/ticket.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TicketEvent {}

class FetchTicket extends TicketEvent {}

class SaveTicket extends TicketEvent {
  SaveTicket(this.ticketData);
  final Ticket ticketData;
}

class RemoveTicket extends TicketEvent {}

class TicketVerified extends TicketEvent {}
