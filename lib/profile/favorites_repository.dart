import 'package:conferenceapp/agenda/repository/talks_repository.dart';
import 'package:conferenceapp/analytics.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/model/user.dart';
import 'package:conferenceapp/profile/user_repository.dart';
import 'package:rxdart/rxdart.dart';

class FavoritesRepository {
  final TalkRepository _talksRepository;
  final UserRepository _userRepository;

  FavoritesRepository(this._talksRepository, this._userRepository);

  Observable<List<Talk>> get favoriteTalks => Observable.combineLatest2(
        _talksRepository.talks(),
        _userRepository.user,
        (List<Talk> talks, User user) => talks
            .where((talk) => user.favoriteTalksIds.contains(talk.id))
            .toList(),
      );

  Future<void> addTalkToFavorites(String talkId) {
    analytics.logEvent(name: 'favorites_add', parameters: {'id': talkId});
    return _userRepository.addTalkToFavorites(talkId);
  }

  Future<void> removeTalkFromFavorites(String talkId) {
    analytics.logEvent(name: 'favorites_remove', parameters: {'id': talkId});
    return _userRepository.removeTalkFromFavorites(talkId);
  }
}
