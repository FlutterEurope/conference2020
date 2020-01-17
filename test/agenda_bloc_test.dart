import 'dart:async';

import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:conferenceapp/agenda/repository/talks_repository.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/model/agenda.dart';
import 'package:conferenceapp/model/author.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'user/auth_repository_test.dart';

class _MockRepository extends Mock implements TalkRepository {}

void main() {
  group('Agenda Bloc tests', () {
    AgendaBloc bloc;
    TalkRepository mockRepo;
    final _tempList = [
      Talk(
        'id1',
        'Title',
        [
          Author(
            '0',
            '',
            '',
            '',
            '',
            '',
          )
        ],
        '',
        DateTime.now(),
        DateTime.now().add(Duration(minutes: 45)),
        Room('', '1'),
        TalkType.other,
      ),
    ];

    setUp(() {
      mockRepo = _MockRepository();
      logger = MockLogger();
      when(mockRepo.talks())
          .thenAnswer((_) => Stream.fromIterable([_tempList]));
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

    test('Populated state talks have the same length as list in repository',
        () async {
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

  group('AgendaPopulatedState tests', () {
    final _authors = [Author('0', '', '', '', '', '')];
    final _room = Room('', '0');
    Talk _tempTalk({int day = 23, hour = 9}) {
      print(hour);
      return Talk(
        'id1',
        '',
        _authors,
        '',
        DateTime(2020, 1, day, hour, 0),
        DateTime(2020, 1, day, hour, 45),
        _room,
        TalkType.other,
      );
    }

    Iterable<Talk> _getMockList(int count,
        {bool singleDay = true, bool sorted = true}) {
      final _list = List<Talk>();
      if (singleDay && sorted) {
        assert(count < 23, "Can't request for more than 23 hours.");
        _list.addAll({
          for (var i = 0; i < count; i++) _tempTalk(hour: i),
        });
      }
      if (!singleDay && sorted) {
        assert(count < 30, "Can't request for more than 30 days.");
        _list.addAll({
          for (var i = 0; i < count; i++) _tempTalk(day: i + 1),
        });
      }
      if (singleDay && !sorted) {
        assert(count < 23, "Can't request for more than 23 hours.");
        _list.addAll({
          for (var i = count; i > 0; i--) _tempTalk(hour: i),
        });
      }
      if (!singleDay && !sorted) {
        assert(count < 30, "Can't request for more than 30 days.");
        _list.addAll({
          for (var i = count; i > 0; i--) _tempTalk(day: i + 1),
        });
      }

      return _list;
    }

    test('Passing empty talk list to state results with empty map', () {
      final state = PopulatedAgendaState(_getMockList(0));
      expect(state.talks, isNotNull);
      expect(state.talks, isEmpty);
      expect(state.talks, isA<Map<int, List<Talk>>>());
    });

    test('Passing 1 talk list to state results with 1 talk map', () {
      final state = PopulatedAgendaState(_getMockList(1));
      expect(state.talks, isNotNull);
      expect(state.talks, hasLength(1));
      expect(state.talks.values.first, hasLength(1));
      expect(state.talks, isA<Map<int, List<Talk>>>());
    });

    test('Passing sorted talk list to state results with map with sorted talks',
        () {
      final length = 10;
      final state = PopulatedAgendaState(_getMockList(length, sorted: true));
      expect(state.talks, isNotNull);
      expect(state.talks.values.first, hasLength(length));
      expect(state.talks, isA<Map<int, List<Talk>>>());
      assert(state.talks.values.first[0].startTime
          .isBefore(state.talks.values.first[1].startTime));
    });

    test(
        'Passing unsorted talk list to state results with map with sorted talks',
        () {
      final state = PopulatedAgendaState(
          _getMockList(10, sorted: false, singleDay: true));
      expect(state.talks, isNotNull);
      expect(state.talks.values.first, hasLength(10));
      expect(state.talks, isA<Map<int, List<Talk>>>());
      assert(state.talks.values.first[0].startTime
          .isBefore(state.talks.values.first[1].startTime));
    });

    test(
        'Passing unsorted talk list with several days results with map with sorted talks per day',
        () {
      final state = PopulatedAgendaState(
          _getMockList(10, sorted: false, singleDay: false));
      expect(state.talks, isNotNull);
      expect(state.talks, hasLength(10));
      expect(state.talks.values.first, hasLength(1));
      expect(state.talks, isA<Map<int, List<Talk>>>());
      assert(state.talks.values.first[0].startTime
          .isBefore(state.talks.values.last[0].startTime));
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
