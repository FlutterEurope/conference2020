import 'package:meta/meta.dart';

import 'package:conferenceapp/model/talk.dart';

@immutable
abstract class RateEvent {}

class RateTalk extends RateEvent {
  RateTalk(this.talk, this.rating);
  final Talk talk;
  final double rating;
}

class ReviewTalk extends RateEvent {
  ReviewTalk(this.talk, this.review);
  final Talk talk;
  final String review;
}

class FetchRateTalk extends RateEvent {
  FetchRateTalk(this.talk);
  final Talk talk;
}
