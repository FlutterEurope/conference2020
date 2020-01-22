import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/model/notification.dart';

class FirestoreNotificationsRepository {
  final CollectionReference _notificationsCollection;
  // final Firestore _firestore;

  FirestoreNotificationsRepository(Firestore firestore)
      : _notificationsCollection = firestore.collection('notifications');

  Stream<List<AppNotification>> notifications() {
    return _notificationsCollection.snapshots().map((snapshot) {
      final list = snapshot.documents.map(_getNotifications).toList();
      list..sort();
      return list;
    });
  }

  AppNotification _getNotifications(DocumentSnapshot doc) {
    try {
      return AppNotification.fromJson(doc.data);
    } catch (e, s) {
      logger.errorException(e, s);
      return AppNotification('', DateTime.now(), '', false, '');
    }
  }

  Future<void> addNotification(AppNotification notification) async {
    final _ = await _notificationsCollection.add(notification.toJson());
  }

  Future<void> removeNotification(String notificationId) async {
    await _notificationsCollection.document(notificationId).delete();
  }
}
