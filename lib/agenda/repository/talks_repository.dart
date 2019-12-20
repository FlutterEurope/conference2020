import 'dart:async';

import 'package:conferenceapp/model/talk.dart';

abstract class TalkRepository {
  Stream<List<Talk>> talks();
  Stream<Talk> talk(String id);
  void refresh();
}
