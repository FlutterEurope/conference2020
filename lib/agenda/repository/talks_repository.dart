import 'package:conferenceapp/model/talk.dart';

abstract class TalkRepository {
  List<Talk> get talks;
}
