import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/utils/analytics.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/model/user.dart';
import 'package:conferenceapp/profile/auth_repository.dart';
import 'package:conferenceapp/profile/user_repository.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLogger extends Mock implements Logger {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockFirestore extends Mock implements Firestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockDocumentReference extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockAnalytics extends Mock implements FirebaseAnalytics {}

main() {
  UserRepository sut;
  MockAuthRepository authRepo;
  MockFirestore firestore;
  MockDocumentSnapshot documentSnapshot;
  MockDocumentReference documentReference;

  setUp(() {
    firestore = MockFirestore();
    authRepo = MockAuthRepository();
    documentReference = MockDocumentReference();
    documentSnapshot = MockDocumentSnapshot();
    logger = MockLogger();
    analytics = MockAnalytics();
  });

  void _initSut() => sut = UserRepository(authRepo, firestore);

  void _makeFirestoreReturnData({
    String userId = 'userId',
    Map<String, dynamic> data = const {
      'userId': 'userId',
      'favoriteTalksIds': []
    },
  }) {
    //prepare document snapshot
    when(documentSnapshot.data).thenReturn(data);
    when(documentSnapshot.exists).thenReturn(true);
    //return document snapshot
    when(documentReference.snapshots())
        .thenAnswer((_) => Stream.value(documentSnapshot));
    when(firestore.document('users/$userId')).thenReturn(documentReference);
  }

  void _makeFirestoreReturnEmptySnapshot({String userId = 'userId'}) {
    //prepare document snapshot
    when(documentSnapshot.exists).thenReturn(false);
    //return document snapshot
    when(documentReference.snapshots())
        .thenAnswer((_) => Stream.value(documentSnapshot));
    when(firestore.document('users/$userId')).thenReturn(documentReference);
  }

  group('user stream', () {
    test('emits nothing when auth repository emits nothing', () {
      //given
      when(authRepo.userId).thenAnswer((_) => Stream.empty());
      //when
      _initSut();
      //then
      expect(sut.user, neverEmits((_) => true));
    });

    test('emits when auth repository emits user id', () {
      //given
      when(authRepo.userId).thenAnswer((_) => Stream.value('userId'));
      _makeFirestoreReturnData();
      //when
      _initSut();
      //then
      expect(sut.user, emits((_) => true));
    });

    test('emits user from firestore if user and uid match', () {
      //given
      _makeFirestoreReturnData(data: {
        'userId': 'userId',
        'favoriteTalksIds': ['id1', 'id2'],
      });
      when(authRepo.userId).thenAnswer((_) => Stream.value('userId'));

      //when
      _initSut();

      //then
      expect(
        sut.user,
        emits((User user) =>
            user.userId == 'userId' &&
            listEquals(user.favoriteTalksIds, ['id1', 'id2'])),
      );
    });

    test(
        'emits user with id and empty list if firestore returns empty snapshot',
        () {
      //given
      when(authRepo.userId).thenAnswer((_) => Stream.value('userId'));
      _makeFirestoreReturnEmptySnapshot();

      //when
      _initSut();

      //then
      expect(
        sut.user,
        emits((User user) =>
            user.userId == 'userId' && listEquals(user.favoriteTalksIds, [])),
      );
    });
  });

  group('addToFavorites', () {
    test('calls firestore with new talkId', () async {
      //given
      when(authRepo.userId).thenAnswer((_) => Stream.value('userId'));
      _makeFirestoreReturnData();
      _initSut();
      await Future.delayed(Duration(milliseconds: 1));
      //when
      await sut.addTalkToFavorites('talkId');
      //then
      verify(documentReference.setData(argThat(
        isA<Map<String, dynamic>>()
            .having((x) => x['userId'], 'userId', 'userId')
            .having(
                (x) => x['favoriteTalksIds'], 'favoriteTalksIds', ['talkId']),
      ))).called(1);
    });

    test('doesnt calls firestore if talkId is already liked', () async {
      //given
      when(authRepo.userId).thenAnswer((_) => Stream.value('userId'));
      _makeFirestoreReturnData(data: {
        'userId': 'userId',
        'favoriteTalksIds': ['talkId'],
      });
      _initSut();
      await Future.delayed(Duration(milliseconds: 1));
      //when
      await sut.addTalkToFavorites('talkId');
      //then
      verifyNever(documentReference.setData(any));
    });
  });

  group('removeFromFavorites', () {
    test('calls firestore without talkId', () async {
      //given
      when(authRepo.userId).thenAnswer((_) => Stream.value('userId'));
      _makeFirestoreReturnData(data: {
        'userId': 'userId',
        'favoriteTalksIds': ['talkId'],
      });
      _initSut();
      await Future.delayed(Duration(milliseconds: 1));
      //when
      await sut.removeTalkFromFavorites('talkId');
      //then
      verify(documentReference.setData(argThat(
        isA<Map<String, dynamic>>()
            .having((x) => x['userId'], 'userId', 'userId')
            .having((x) => x['favoriteTalksIds'], 'favoriteTalksIds', []),
      ))).called(1);
    });

    test('doesnt calls firestore if talkId is not liked', () async {
      //given
      when(authRepo.userId).thenAnswer((_) => Stream.value('userId'));
      _makeFirestoreReturnData();
      _initSut();
      await Future.delayed(Duration(milliseconds: 1));
      //when
      await sut.removeTalkFromFavorites('talkId');
      //then
      verifyNever(documentReference.setData(any));
    });
  });
}
