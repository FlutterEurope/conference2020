import 'package:meta/meta.dart';

@immutable
abstract class TicketEvent {}

class FetchTicket extends TicketEvent {}

class FillTicketData extends TicketEvent {}

class SaveTicket extends TicketEvent {
  final String orderId;
  final String email;

  SaveTicket(this.orderId, this.email);
}
