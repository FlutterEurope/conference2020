import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:conferenceapp/model/ticket.dart';
import 'package:conferenceapp/model/user.dart';
import 'package:conferenceapp/profile/user_repository.dart';
import 'package:vibration/vibration.dart';
import './bloc.dart';
import 'package:conferenceapp/ticket/repository/ticket_repository.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository _ticketRepository;
  final UserRepository _userRepository;
  StreamSubscription<User> _userSub;

  TicketBloc(this._ticketRepository, this._userRepository) {
    _userSub = _userRepository.user.listen(handleUser);
  }

  void handleUser(User data) {
    if (data.ticketId != null) {
      add(TicketVerified());
    }
    if (data.ticketId == null && state is TicketAddedState) {
      add(FetchTicket());
    }
  }

  @override
  String toString() => 'TicketBloc';

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
    if (event is TicketVerified) {
      if (state is TicketAddedState) {
        final ticket = (state as TicketAddedState).ticket;
        Vibration.vibrate(duration: 300);
        yield TicketValidatedState(ticket);
      }
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
      final ticket = Ticket(
          event.ticketData.orderId?.toUpperCase(), event.ticketData.ticketId);

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

  @override
  Future<void> close() {
    _userSub.cancel();
    return super.close();
  }
}
