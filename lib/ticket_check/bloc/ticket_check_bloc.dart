import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/model/ticket.dart';
import './bloc.dart';

class TicketCheckBloc extends Bloc<TicketCheckEvent, TicketCheckState> {
  final ticketCollection = Firestore.instance.collection('tickets');

  @override
  String toString() => 'TicketCheckBloc';

  @override
  TicketCheckState get initialState => NoTicketCheckState();

  @override
  Stream<TicketCheckState> mapEventToState(
    TicketCheckEvent event,
  ) async* {
    if (event is InitEvent) {
      yield NoTicketCheckState();
    }
    if (event is TicketScanned) {
      yield* handleTicketScanned(event);
    }

    if (event is TickedValidated) {
      yield* handleTicketValidated(event);
    }
  }

  Stream<TicketCheckState> handleTicketValidated(TickedValidated event) async* {
    try {
      yield LoadingState();
      final user = Firestore.instance.document('users/${event.userId}');
      user.setData(
        {
          'ticketId': event.ticket.ticketId,
          'orderId': event.ticket.orderId,
          'updated': DateTime.now(),
        },
        merge: true,
      );
      yield TicketValidatedState(event.ticket, event.userId);
    } catch (e) {
      print(e);
      yield TicketErrorState('Error during marking as present.');
    }
  }

  Stream<TicketCheckState> handleTicketScanned(TicketScanned event) async* {
    yield LoadingState();
    try {
      final values = event.valueRead.split(' ');
      final userId = values[0];
      final orderId =
          values[1].contains('OT') ? values[1].substring(2) : values[1];
      final ticketId = values[2];
      final matchigTickets = await getMatchingTickets(orderId, ticketId);
      if (matchigTickets.length > 0) {
        final selectedTicket = matchigTickets
            .firstWhere((n) => n['used'] == false, orElse: () => null);
        print(selectedTicket);

        if (selectedTicket == null) {
          yield TicketErrorState('All valid tickets have already been used.');
          return;
        }

        final matchingOrderId = selectedTicket['orderId'];
        final matchingTicketId = selectedTicket['ticketId'];
        final matchingEmail = selectedTicket['email'];
        final matchingName = selectedTicket['name'];
        final matchingType = selectedTicket['type'];

        final name = utf8.decode(base64Decode(matchingName));
        yield TicketScannedState(
          Ticket(matchingOrderId, matchingTicketId),
          userId,
          name,
          matchingType == 'Student',
        );
      } else {
        yield TicketErrorState('No valid tickets found.');
      }
    } catch (e) {
      print(e);
      yield TicketErrorState(
          'There was a problem with processing the scan. Please try again.');
    }
  }

  Future<List> getMatchingTickets(String orderId, String ticketId) async {
    final ticketCollection = await getTicketsCollection();

    final checkByOrder = isCheckedByOrder(orderId);
    final matchigTickets = ticketCollection
        .where(checkByOrder
            ? (t) => t['orderId'] == orderId
            : (t) => t['ticketId'] == ticketId)
        .toList();
    return matchigTickets;
  }

  bool isCheckedByOrder(String orderId) {
    return orderId.length > 1;
  }

  Future<List> getTicketsCollection() async {
    final tickets =
        await Firestore.instance.document('tickets/tickets').snapshots().first;

    final List ticketCollection = tickets.data['tickets'];
    return ticketCollection;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
