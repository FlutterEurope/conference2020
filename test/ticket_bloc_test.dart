import 'dart:async';

import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/model/ticket.dart';
import 'package:conferenceapp/model/user.dart';
import 'package:conferenceapp/profile/user_repository.dart';
import 'package:conferenceapp/ticket/bloc/bloc.dart';
import 'package:conferenceapp/ticket/repository/ticket_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'user/auth_repository_test.dart';

class _MockTicketRepository extends Mock implements TicketRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('Ticket Bloc tests when ticket present in cache', () {
    TicketBloc bloc;
    TicketRepository _ticketRepository;
    UserRepository _userRepository;

    setUp(() {
      logger = MockLogger();
      _ticketRepository = _MockTicketRepository();
      _userRepository = _MockUserRepository();
      userRepositoryAlwaysWorks(_userRepository);
      ticketRepositoryAlwaysWorks(_ticketRepository);
      bloc = TicketBloc(
        _ticketRepository,
        _userRepository,
      );
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

void userRepositoryAlwaysWorks(UserRepository _userRepository) =>
    when(_userRepository.user)
        .thenAnswer((_) => Stream.value(User('userId', [], null)));
