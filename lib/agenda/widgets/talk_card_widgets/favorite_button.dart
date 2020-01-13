import 'package:conferenceapp/config.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    Key key,
    @required this.isFavorite,
    @required this.talk,
  }) : super(key: key);

  final bool isFavorite;

  final Talk talk;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onPressed(context),
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    final favoritesRepo = RepositoryProvider.of<FavoritesRepository>(context);
    final flutterLocalNotificationsPlugin =
        Provider.of<FlutterLocalNotificationsPlugin>(context, listen: false);
    final sharedPrefs = Provider.of<SharedPreferences>(context, listen: false);
    final remindersEnabled = sharedPrefs.getBool('reminders') == true;
    if (isFavorite) {
      favoritesRepo.removeTalkFromFavorites(talk?.id);
      cancelNotification(flutterLocalNotificationsPlugin);
      hideInfoAboutNotification(context);
    } else {
      favoritesRepo.addTalkToFavorites(talk?.id);
      if (remindersEnabled) {
        scheduleNotification(
            flutterLocalNotificationsPlugin, favoritesRepo, talk);

        showInfoAboutNotification(context);
      }
    }
  }

  void cancelNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    await flutterLocalNotificationsPlugin.cancel(talk.id.hashCode);
    await flutterLocalNotificationsPlugin.cancel(talk.id.hashCode + 1);
  }

  void showInfoAboutNotification(BuildContext context) {
    final suffix = appConfig.flavor != 'prod'
        ? ' (in test mode notification will appear in 20 seconds)'
        : '';
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        'We\'ll let you know when the talk starts$suffix',
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).accentColor,
    ));
  }

  void scheduleNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      FavoritesRepository favoritesRepo,
      Talk talk) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'notifications',
      'App Notifications',
      'Various notifications from the app',
      importance: Importance.Max,
      priority: Priority.Max,
      ticker: 'Flutter Europe',
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    final reminderTime = _reminderTime();

    final title = '${talk.title}' +
        (talk.authors.isNotEmpty ? 'by ' : '') +
        talk.authors.join(", ");
    await flutterLocalNotificationsPlugin.schedule(
      talk.id.hashCode,
      'Next talk starts in 5 minutes',
      title,
      reminderTime,
      platformChannelSpecifics,
      payload: talk.id,
    );

    final ratingTime = _ratingTime();

    await flutterLocalNotificationsPlugin.schedule(
      talk.id.hashCode + 1,
      'Please rate the talk',
      title,
      ratingTime,
      platformChannelSpecifics,
      payload: talk.id,
    );
  }

  DateTime _reminderTime() {
    if (appConfig.flavor != 'prod') {
      return DateTime.now().add(Duration(seconds: 20));
    } else {
      return talk.startTime.subtract(Duration(minutes: 5));
    }
  }

  DateTime _ratingTime() {
    if (appConfig.flavor != 'prod') {
      return DateTime.now().add(Duration(seconds: 40));
    } else {
      return talk.endTime.subtract(Duration(minutes: 5));
    }
  }

  void hideInfoAboutNotification(BuildContext context) {
    Scaffold.of(context).hideCurrentSnackBar();
  }
}
