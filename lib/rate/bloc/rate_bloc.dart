import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/rate/repository/ratings_repository.dart';
import './bloc.dart';

class RateBloc extends Bloc<RateEvent, RateState> {
  RateBloc(this._ratingsRepository);

  final RatingsRepository _ratingsRepository;

  double _rating;
  double get rating => _rating;

  @override
  RateState get initialState => InitialRateState();

  @override
  Stream<RateState> transformEvents(
      Stream<RateEvent> events, Stream<RateState> Function(RateEvent) next) {
    final nonRateTalkStream = events.where((event) => event is! RateTalk);
    final rateTalkStream = events
        .where((event) => event is RateTalk)
        .throttleTime(Duration(milliseconds: 500));

    return MergeStream([nonRateTalkStream, rateTalkStream]).switchMap(next);
  }

  @override
  Stream<RateState> mapEventToState(
    RateEvent event,
  ) async* {
    if (event is RateTalk) {
      try {
        final canRateTime = event.talk.endTime.subtract(Duration(minutes: 5));
        if (DateTime.now().isAfter(canRateTime)) {
          _ratingsRepository.rateTalk(event.talk.id, event.rating.toInt());
          _rating = event.rating;
          yield TalkRatedState();
        } else {
          yield RatingTalkToEarlyErrorState();
        }
      } catch (e, s) {
        logger.errorException(e, s);
        yield RatingTalkErrorState();
      }
    } else if (event is FetchRateTalk) {
      _rating = _ratingsRepository.myRatingOfTalk(event.talk.id)?.toDouble();
      yield TalkRateFetched();
    }
  }
}
