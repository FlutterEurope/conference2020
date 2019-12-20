import 'package:conferenceapp/model/ticket.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TicketState extends Equatable {}

class NoTicketState extends TicketState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class TicketLoadingState extends TicketState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class TicketValidState extends TicketState {
  final Ticket ticket;

  TicketValidState(this.ticket);

  @override
  // TODO: implement props
  List<Object> get props => [ticket.orderId, ticket.ticketId];
}

class TicketErrorState extends TicketState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
