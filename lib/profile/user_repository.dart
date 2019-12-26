import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/model/user.dart';
import 'package:conferenceapp/profile/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class UserRepository {
  final AuthRepository _authRepository;
  final Firestore _firestore;
  User _cachedUser;

  UserRepository(this._authRepository, this._firestore) {
    this.user.listen((user) {
      _cachedUser = user;
    });
  }

  Stream<DocumentSnapshot> get _usersSnapshotsStream => _authRepository.userId
      .asyncExpand((id) => _firestore.document('users/$id').snapshots());

  Stream<User> get user => Observable.combineLatest2(
        _authRepository.userId,
        _usersSnapshotsStream,
        _getUserFromSnapshot,
      ).asBroadcastStream();

  Future<void> addTalkToFavorites(String talkId) async {
    if (_cachedUser.favoriteTalksIds.contains(talkId)) {
      return;
    }

    await _firestore.document('users/${_cachedUser.userId}').setData({
      'userId': _cachedUser.userId,
      'favoriteTalksIds': _cachedUser.favoriteTalksIds..add(talkId),
    });
  }

  Future<void> removeTalkFromFavorites(String talkId) async {
    if (!_cachedUser.favoriteTalksIds.contains(talkId)) {
      return;
    }
    await _firestore.document('users/${_cachedUser.userId}').setData({
      'userId': _cachedUser.userId,
      'favoriteTalksIds': _cachedUser.favoriteTalksIds..remove(talkId),
    });
  }

  User _getUserFromSnapshot(
    String id,
    DocumentSnapshot userSnapshot,
  ) {
    if (userSnapshot.exists) {
      return User.fromJson(userSnapshot.data);
    } else {
      return User(id, [], false);
    }
  }
}
