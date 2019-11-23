import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: NotificationsEmptyState(),
      ),
    );
  }
}

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/notifications.png',
            height: 200,
            width: 200,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Here you will see your notifications and messages from organizers',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
