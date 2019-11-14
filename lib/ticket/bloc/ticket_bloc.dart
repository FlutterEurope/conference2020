import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:conferenceapp/model/ticket.dart';
import './bloc.dart';
import 'package:conferenceapp/ticket/repository/ticket_repository.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository;

  TicketBloc(this.ticketRepository);

  @override
  TicketState get initialState => NoTicketState();

  @override
  Stream<TicketState> mapEventToState(
    TicketEvent event,
  ) async* {
    if (event is FetchTicket) {
      yield* mapFetchTicketToState(event);
    }
    if (event is FillTicketData) {
      yield* mapFillTicketDataToState(event);
    }
    if (event is SaveTicket) {
      yield* mapSaveTicketToState(event);
    }
  }

  Stream<TicketState> mapFetchTicketToState(FetchTicket event) async* {
    final ticket = await ticketRepository.getTicket();
    if (ticket != null) {
      yield TicketValidState();
    } else {
      yield NoTicketState();
    }
  }

  Stream<TicketState> mapFillTicketDataToState(FillTicketData event) async* {
    yield TicketDataFilledState();
  }

  Stream<TicketState> mapSaveTicketToState(SaveTicket event) async* {
    if (event.ticketData.email != null && event.ticketData.orderId != null) {
      yield TicketLoadingState();
      await Future.delayed(Duration(seconds: 1));
      // fetch from eventil
      final ticket = Ticket(event.ticketData.orderId, '', event.ticketData.email, TicketType.Blind);

      await ticketRepository.addTicket(ticket);
      yield TicketValidState();
    } else {
      yield TicketErrorState();
    }
  }
}
