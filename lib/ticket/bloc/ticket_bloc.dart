import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  @override
  TicketState get initialState => InitialTicketState();

  @override
  Stream<TicketState> mapEventToState(
    TicketEvent event,
  ) async* {
    if (event is AddTicket) {
      yield* mapAddTicketToState(event);
    }
  }

  Stream<TicketState> mapAddTicketToState(AddTicket event) async* {
    if (event is AddTicketFromCamera) {
      //TODO
    } else if (event is AddTicketManually) {
      //TODO
    }
  }
}
