import 'package:meta/meta.dart';

import 'package:conferenceapp/model/talk.dart';

@immutable
abstract class RateEvent {}

class RateTalk extends RateEvent {
  RateTalk(this.talk, this.rating);
  final Talk talk;
  final double rating;
}

class FetchRateTalk extends RateEvent {
  FetchRateTalk(this.talk);
  final Talk talk;
}
