import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/profile/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirestore extends Mock implements Firestore {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

class MockLogger extends Mock implements Logger {}

main() {
  group('AuthRepository', () {
    setUp(() {
      logger = MockLogger();
    });

    test('forwards user id when user is emitted', () {
      //given
      //ignore: close_sinks
      final userEmitter = StreamController<FirebaseUser>();
      MockFirebaseAuth auth = MockFirebaseAuth();
      when(auth.onAuthStateChanged).thenAnswer((_) => userEmitter.stream);

      MockFirestore firestore = MockFirestore();

      MockFirebaseUser user = MockFirebaseUser();
      when(user.uid).thenReturn('test uid');

      AuthRepository sut = AuthRepository(auth, firestore);
      //when
      userEmitter.add(user);
      //then
      expect(sut.userId, emits('test uid'));
    });
  });
}
