import 'dart:async';

import 'package:conferenceapp/profile/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements FirebaseUser {}

main() {
  group('AuthRepository', () {
    test('calls Firebase auth to log in when created', () {
      //given
      MockFirebaseAuth auth = MockFirebaseAuth();
      //when
      AuthRepository sut = AuthRepository(auth);
      //then
      verify(auth.signInAnonymously()).called(1);
    });

    test('forwards user id when user is emitted', () {
      //given
      //ignore: close_sinks
      final userEmitter = StreamController<FirebaseUser>();
      MockFirebaseAuth auth = MockFirebaseAuth();
      when(auth.onAuthStateChanged).thenAnswer((_) => userEmitter.stream);

      MockFirebaseUser user = MockFirebaseUser();
      when(user.uid).thenReturn('test uid');

      AuthRepository sut = AuthRepository(auth);
      //when
      userEmitter.add(user);
      //then
      expect(sut.userId, emits('test uid'));
    });
  });
}
