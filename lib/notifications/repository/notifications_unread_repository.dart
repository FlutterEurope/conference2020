import 'package:conferenceapp/model/notification.dart';
import 'package:conferenceapp/notifications/repository/notifications_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotificationsUnreadStatusRepository {
  final FirestoreNotificationsRepository notificationsRepository;
  final SharedPreferences sharedPreferences;
  final String _sharedPrefKey = 'notif_last_read';

  AppNotificationsUnreadStatusRepository(
      this.notificationsRepository, this.sharedPreferences);

  Stream<bool> hasUnreadNotifications() => Observable.combineLatest2(
        notificationsRepository.notifications(),
        _lastNotificationReadTime(),
        _combine,
      );

  void setLatestNotificationReadTime() {
    sharedPreferences.setInt(
        _sharedPrefKey, DateTime.now().microsecondsSinceEpoch);
  }

  Stream<int> _lastNotificationReadTime() {
    try {
      final value = sharedPreferences.getInt(_sharedPrefKey);
      return Observable.just(value);
    } catch (e) {
      // do nothing;
    }
    return Observable.just(null);
  }

  bool _combine(List<AppNotification> list, int lastRead) {
    if (lastRead != null) {
      final time = DateTime.fromMicrosecondsSinceEpoch(lastRead);
      if (list.isNotEmpty && list.length > 0) {
        return list.first.dateTime.compareTo(time) > 0;
      }
      return false;
    }
    return false;
  }
}
