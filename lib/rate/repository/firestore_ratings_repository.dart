import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/profile/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ratings_repository.dart';

class FirestoreRatingsRepository implements RatingsRepository {
  final SharedPreferences _sharedPreferences;
  final Firestore _firestore;
  final UserRepository _userRepository;

  FirestoreRatingsRepository(
      this._sharedPreferences, this._firestore, this._userRepository);

  @override
  int myRatingOfTalk(String talkId) {
    try {
      return _sharedPreferences.getInt(talkId);
    } catch (e, s) {
      logger.errorException(e, s);
      return null;
    }
  }

  @override
  void rateTalk(String talkId, int rating) async {
    try {
      _sharedPreferences.setInt(talkId, rating);
    } catch (e, s) {
      logger.errorException(e, s);
    }

    try {
      final user = await _userRepository.user.first;

      if (user == null) {
        logger.warn("Cannot rate talk $talkId because user is null.");
        return;
      }

      final ratingsCollection = _firestore.collection("ratings");
      final myTalkRating = (await ratingsCollection
              .where("user_id", isEqualTo: user.userId)
              .where("talk_id", isEqualTo: talkId)
              .getDocuments())
          .documents
          .firstOrDefault();

      if (myTalkRating != null && myTalkRating.exists) {
        myTalkRating.reference
            .updateData({"rating": rating, "update_date": Timestamp.now()});
      } else {
        ratingsCollection.add({
          "user_id": user.userId,
          "talk_id": talkId,
          "rating": rating,
          "update_date": Timestamp.now()
        });
      }
    } catch (e, s) {
      logger.errorException(e, s);
    }
  }
}

extension ListOperations on List<DocumentSnapshot> {
  DocumentSnapshot firstOrDefault() {
    return this.length > 0 ? this.first : null;
  }
}
