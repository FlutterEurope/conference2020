import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUtils {
  static DateTime fromJson(Timestamp val) => val == null || val.millisecondsSinceEpoch == null
      ? DateTime(2000, 1, 1)
      : DateTime.fromMillisecondsSinceEpoch(val.millisecondsSinceEpoch);
  static Timestamp toJson(DateTime time) => Timestamp.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
}
