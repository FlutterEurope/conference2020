import 'package:meta/meta.dart';

@immutable
abstract class RateState {}

class InitialRateState extends RateState {}

class TalkRateFetched extends RateState {}

class TalkRatedState extends RateState {}

class RatingTalkErrorState extends RateState {}

class RatingTalkToEarlyErrorState extends RateState {}
