import 'dart:async';

import 'package:conferenceapp/model/ticket.dart';
import 'package:conferenceapp/ticket/bloc/bloc.dart';
import 'package:conferenceapp/ticket/repository/ticket_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class _MockTicketRepository extends Mock implements TicketRepository {}

void main() {
  group('Agenda Bloc tests when ticket present in cache', () {
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
            isA<TicketValidState>(),
          ]));
    });

    // test('Populated state talks have the same length as list in repository',
    //     () async {
    //   await initializeBloc(bloc);

    //   expectLater(
    //       bloc,
    //       emitsInOrder([
    //         isA<LoadingAgendaState>(),
    //         isA<PopulatedAgendaState>().having(
    //           (e) => e.talks,
    //           'talks',
    //           hasLength(_tempList.length),
    //         ),
    //       ]));
    // });

    tearDown(() {
      bloc.close();
    });
  });
}

void ticketRepositoryAlwaysWorks(TicketRepository _ticketRepository) {
  when(_ticketRepository.getTicket()).thenAnswer((_) =>
      Future.value(Ticket('test', 'test', 'test@test.com', TicketType.Blind)));
  when(_ticketRepository.addTicket(any)).thenAnswer((_) => Future.value(true));
  when(_ticketRepository.removeTicket())
      .thenAnswer((_) => Future.value(true));
}
