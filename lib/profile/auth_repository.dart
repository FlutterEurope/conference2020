import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth) {
    _firebaseAuth.signInAnonymously();
  }

  Stream<String> get userId =>
      _firebaseAuth.onAuthStateChanged.map((user) => user.uid);
}
