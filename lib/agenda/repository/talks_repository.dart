import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/model/talk_list.dart';

abstract class TalkRepository {
  Stream<List<Talk>> talks();
}

class FirestoreTalkRepository implements TalkRepository {
  final talksCollection = Firestore.instance.collection('talks').where("public", isEqualTo: true);

  @override
  Stream<List<Talk>> talks() {
    return talksCollection.snapshots().map((snapshot) {
      final list = snapshot.documents.map(getTalks).toList();
      return list.expand((l) => l.talks).toList();
    });
  }

  TalkList getTalks(doc) {
    try {
      return TalkList.fromJson(doc.data);
    } catch (e) {
      print(e);
      return TalkList(DateTime(2000, 1, 1), List<Talk>());
    }
  }
}
