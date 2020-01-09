import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/model/talk_list.dart';

import 'talks_repository.dart';

class FirestoreTalkRepository implements TalkRepository {
  final talksCollection =
      Firestore.instance.collection('talks').where("public", isEqualTo: true);

  @override
  Stream<List<Talk>> talks() {
    return talksCollection.snapshots().map((snapshot) {
      final list = snapshot.documents.map(getTalks).toList();
      return list.expand((l) => l.talks).toList();
    });
  }

  @override
  Stream<Talk> talk(String id) {
    StreamTransformer<List<Talk>, Talk> transform =
        StreamTransformer.fromHandlers(
      handleData: (List<Talk> data, EventSink<Talk> sink) {
        sink.add(data.firstWhere((t) => t.id == id, orElse: () => null));
      },
      handleError: (Object error, StackTrace stacktrace, EventSink sink) {
        sink.addError('Something went wrong: $error');
      },
      handleDone: (EventSink<Talk> sink) => sink.close(),
    );

    return talks().transform(transform);
  }

  TalkList getTalks(doc) {
    try {
      return TalkList.fromJson(doc.data);
    } catch (e, s) {
      logger.errorException(e, s);
      return TalkList(DateTime(2000, 1, 1), List<Talk>());
    }
  }

  @override
  void refresh() {
    // TODO: implement refresh
  }
}
