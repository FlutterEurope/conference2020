import 'package:conferenceapp/model/ticket.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TicketCheckState {}

class NoTicketCheckState extends TicketCheckState {}

class LoadingState extends TicketCheckState {}

class TicketScannedState extends TicketCheckState {
  final Ticket ticket;
  final String userId;
  final String name;
  final bool student;
  final int ticketsInOrderCount;
  final int leftTicketsInOrderCount;
  final bool ticketChecked;

  TicketScannedState(
      this.ticket,
      this.userId,
      this.name,
      this.student,
      this.ticketsInOrderCount,
      this.leftTicketsInOrderCount,
      this.ticketChecked);
}

class TicketValidatedState extends TicketCheckState {
  final Ticket ticket;
  final String userId;

  TicketValidatedState(this.ticket, this.userId);
}

class TicketErrorState extends TicketCheckState {
  final String reason;

  TicketErrorState(this.reason);
}
