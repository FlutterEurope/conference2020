import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/model/user.dart';
import 'package:conferenceapp/profile/auth_repository.dart';
import 'package:flutter_bugfender/flutter_bugfender.dart';
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

  Stream<DocumentSnapshot> get _usersSnapshotsStream {
    return _authRepository.userId.asyncExpand((id) {
      if (id == null) return null;

      return _firestore.document('users/$id').snapshots();
    });
  }

  Stream<User> get user => Rx.combineLatest2(
        _authRepository.userId,
        _usersSnapshotsStream,
        _getUserFromSnapshot,
      ).asBroadcastStream();

  Future<void> addTalkToFavorites(String talkId) async {
    if (_cachedUser.favoriteTalksIds.contains(talkId)) {
      return;
    }

    FlutterBugfender.setDeviceString('userId', _cachedUser.userId);

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
    if (id != userSnapshot.documentID || id != _cachedUser?.userId) {
      Logger.warn('Wrong auth id of cached user');
    }
    if (userSnapshot.exists) {
      final user = User.fromJson(userSnapshot.data);
      _cachedUser = user;
      return user;
    } else {
      return User(id, []);
    }
  }
}
