import 'package:conferenceapp/ticket/ticket_data.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TicketEvent {}

class FetchTicket extends TicketEvent {}

// class FillTicketData extends TicketEvent {
//   FillTicketData(this.ticketData);
//   final TicketData ticketData;
// }

class SaveTicket extends TicketEvent {
  SaveTicket(this.ticketData);
  final TicketData ticketData;
}
