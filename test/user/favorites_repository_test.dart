import 'package:conferenceapp/agenda/repository/talks_repository.dart';
import 'package:conferenceapp/utils/analytics.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/model/user.dart';
import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:conferenceapp/profile/user_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockTalksRepository extends Mock implements TalkRepository {}

class MockAnalytics extends Mock implements FirebaseAnalytics {}

main() {
  MockUserRepository userRepository;
  MockTalksRepository talksRepository;
  FavoritesRepository sut;

  setUp(() {
    userRepository = MockUserRepository();
    talksRepository = MockTalksRepository();
    sut = FavoritesRepository(talksRepository, userRepository);
    analytics = MockAnalytics();
  });

  Talk talkFromId(String id) => Talk(id, null, null, null, null, null, null, null);

  void makeUserRepoReturn(List<String> favorites) => when(userRepository.user)
      .thenAnswer((_) => Stream.value(User('userId', favorites, null)));

  void makeTalksRepoReturn(List<String> ids) => when(talksRepository.talks())
      .thenAnswer((_) => Stream.value(ids.map(talkFromId).toList()));

  group('favoriteTalks', () {
    test('returns empty if there are no matching ids', () {
      //given
      makeUserRepoReturn(['id0', 'id3']);
      makeTalksRepoReturn(['id1', 'id2']);
      //when
      //then
      expect(sut.favoriteTalks, emits([]));
    });

    test('returns talks with maching ids', () {
      //given
      makeUserRepoReturn(['id1']);
      makeTalksRepoReturn(['id1', 'id2', 'id3']);
      //when
      //then
      expect(
        sut.favoriteTalks,
        emits((List<Talk> listOfTalks) =>
            listOfTalks.length == 1 && listOfTalks.first.id == 'id1'),
      );
    });

    test('addToFavorites calls user repository', () {
      //given
      //when
      sut.addTalkToFavorites('talkId');
      //then
      verify(userRepository.addTalkToFavorites('talkId')).called(1);
    });

    test('removeFromFavorites calls user repository', () {
      //given
      //when
      sut.removeTalkFromFavorites('talkId');
      //then
      verify(userRepository.removeTalkFromFavorites('talkId')).called(1);
    });
  });
}
