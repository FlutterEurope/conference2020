import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showRatingTalkTooEarlyError(BuildContext context) {
  final config = Provider.of<RemoteConfig>(context, listen: false);
  final minutes = config?.getInt("minutes_before_talk_can_be_rated") ?? 5;

  Scaffold.of(context).removeCurrentSnackBar();
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(
          "Talk can be rated $minutes minutes before the presentation is finished."),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).accentColor,
    ),
  );
}
