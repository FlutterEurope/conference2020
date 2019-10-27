import 'dart:async';

import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:conferenceapp/agenda/repository/talks_repository.dart';
import 'package:conferenceapp/model/author.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class _MockRepository extends Mock implements TalkRepository {}

void main() {
  group('Agenda Bloc tests', () {
    AgendaBloc bloc;
    TalkRepository mockRepo;
    final _tempList = [
      Talk(
        '',
        [Author('', '', '', '', '', '', '', 0)],
        DateTime.now(),
        Duration(minutes: 1),
        Room('', 100, 1),
        0,
      ),
    ];

    setUp(() {
      mockRepo = _MockRepository();
      when(mockRepo.talks()).thenAnswer((_) => Stream.fromIterable([_tempList]));
      bloc = AgendaBloc(mockRepo);
    });

    test('Initial state is correct', () {
      expect(bloc.initialState, isA<InitialAgendaState>());
    });

    test('InitAgenda event subscribes to the repository stream', () async {
      await initializeBloc(bloc);

      verify(mockRepo.talks());
    });

    test('UpdateEvent yields populated state', () async {
      bloc.add(AgendaUpdated(_tempList));

      await expectLater(
          bloc,
          emitsInOrder([
            isA<InitialAgendaState>(),
            isA<PopulatedAgendaState>().having(
              (e) => e.talks,
              'talks',
              hasLength(_tempList.length),
            ),
          ]));
    });

    test('Populated state talks have the same length as list in repository', () async {
      await initializeBloc(bloc);

      expectLater(
          bloc,
          emitsInOrder([
            isA<LoadingAgendaState>(),
            isA<PopulatedAgendaState>().having(
              (e) => e.talks,
              'talks',
              hasLength(_tempList.length),
            ),
          ]));
    });

    tearDown(() {
      bloc.close();
    });
  });
}

Future initializeBloc(AgendaBloc bloc) async {
  bloc.add(InitAgenda());

  await expectLater(
      bloc,
      emitsInOrder([
        isA<InitialAgendaState>(),
        isA<LoadingAgendaState>(),
      ]));
}
