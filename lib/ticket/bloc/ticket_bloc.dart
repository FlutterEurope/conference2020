import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:conferenceapp/model/ticket.dart';
import './bloc.dart';
import 'package:conferenceapp/ticket/repository/ticket_repository.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository _ticketRepository;

  TicketBloc(this._ticketRepository);

  @override
  TicketState get initialState => NoTicketState();

  @override
  Stream<TicketState> mapEventToState(
    TicketEvent event,
  ) async* {
    if (event is FetchTicket) {
      yield* mapFetchTicketToState(event);
    }
    if (event is SaveTicket) {
      yield* mapSaveTicketToState(event);
    }
    if (event is RemoveTicket) {
      yield* mapRemoveTicketToState(event);
    }
  }

  Stream<TicketState> mapFetchTicketToState(FetchTicket event) async* {
    final ticket = await _ticketRepository.getTicket();
    if (ticket != null) {
      yield TicketAddedState(ticket);
    } else {
      yield NoTicketState();
    }
  }

  Stream<TicketState> mapSaveTicketToState(SaveTicket event) async* {
    if (event.ticketData.ticketId != null || event.ticketData.orderId != null) {
      yield TicketLoadingState();
      final ticket =
          Ticket(event.ticketData.orderId?.toUpperCase(), event.ticketData.ticketId);

      await _ticketRepository.addTicket(ticket);
      yield TicketAddedState(ticket);
    } else {
      yield TicketErrorState();
    }
  }

  Stream<TicketState> mapRemoveTicketToState(RemoveTicket event) async* {
    final removed = await _ticketRepository.removeTicket();
    if (removed) {
      yield NoTicketState();
    } else {
      final ticket = await _ticketRepository.getTicket();
      yield TicketAddedState(ticket);
    }
  }
}
