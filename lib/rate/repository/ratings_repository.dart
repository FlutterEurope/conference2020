abstract class RatingsRepository {
  int myRatingOfTalk(String talkId);
  String myReviewOfTalk(String talkId);
  void rateTalk(String talkId, int rating);
  void reviewTalk(String talkId, String review);
}
