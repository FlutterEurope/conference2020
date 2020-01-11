import 'package:conferenceapp/model/ticket.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TicketState extends Equatable {}

class NoTicketState extends TicketState {
  @override
  List<Object> get props => null;
}

class TicketLoadingState extends TicketState {
  @override
  List<Object> get props => null;
}

class TicketAddedState extends TicketState {
  final Ticket ticket;

  TicketAddedState(this.ticket);

  @override
  List<Object> get props => [ticket.orderId, ticket.ticketId];
}

class TicketValidatedState extends TicketAddedState {
  final Ticket ticket;

  TicketValidatedState(this.ticket) : super(ticket);

  @override
  List<Object> get props => [ticket.orderId, ticket.ticketId];
}

class TicketErrorState extends TicketState {
  @override
  List<Object> get props => null;
}
