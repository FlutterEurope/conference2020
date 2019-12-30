import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final _adminsCollection = Firestore.instance.collection('admins');

  AuthRepository(this._firebaseAuth) {
    _init();
  }

  void _init() async {
    final user = await _firebaseAuth.currentUser();
    if (user == null) {
      _firebaseAuth.signInAnonymously();
    }
    if (user?.isAnonymous == false || user?.isEmailVerified == true) {
      print(user.uid);
    }
  }

  Stream<String> get userId => _firebaseAuth.onAuthStateChanged.map((user) {
        // print('User changed to ${user?.uid}');
        if (user != null)
          return user.uid;
        else {
          _firebaseAuth.signInAnonymously();
          return null;
        }
      });

  Stream<bool> get isAdmin => Observable.combineLatest2(
        userId,
        _adminsSnapshotsStream,
        _isUserAdmin,
      ).asBroadcastStream();

  Stream<List<DocumentSnapshot>> get _adminsSnapshotsStream =>
      _adminsCollection.snapshots().map((docs) => docs.documents.toList());

  bool _isUserAdmin(
    String id,
    List<DocumentSnapshot> adminsSnapshot,
  ) {
    try {
      if (adminsSnapshot.length > 0) {
        final isAdmin = adminsSnapshot.firstWhere((f) {
          return f.data["id"] == id;
        }, orElse: () => null);
        return isAdmin != null;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
