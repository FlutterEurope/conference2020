import 'dart:async';

import 'package:conferenceapp/model/ticket.dart';
import 'package:conferenceapp/ticket/bloc/bloc.dart';
import 'package:conferenceapp/ticket/repository/ticket_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class _MockTicketRepository extends Mock implements TicketRepository {}

void main() {
  group('Ticket Bloc tests when ticket present in cache', () {
    TicketBloc bloc;
    TicketRepository _ticketRepository;

    setUp(() {
      _ticketRepository = _MockTicketRepository();
      ticketRepositoryAlwaysWorks(_ticketRepository);
      bloc = TicketBloc(_ticketRepository);
    });

    test('Initial state is correct', () {
      expect(bloc.initialState, isA<NoTicketState>());
    });

    test('Fetching ticket yields TicketDataFilledState', () async {
      bloc.add(FetchTicket());

      await expectLater(
          bloc,
          emitsInOrder([
            isA<NoTicketState>(),
            isA<TicketAddedState>(),
          ]));
    });

    tearDown(() {
      bloc.close();
    });
  });
}

void ticketRepositoryAlwaysWorks(TicketRepository _ticketRepository) {
  when(_ticketRepository.getTicket())
      .thenAnswer((_) => Future.value(Ticket('test', 'test')));
  when(_ticketRepository.addTicket(any)).thenAnswer((_) => Future.value(true));
  when(_ticketRepository.removeTicket()).thenAnswer((_) => Future.value(true));
}
