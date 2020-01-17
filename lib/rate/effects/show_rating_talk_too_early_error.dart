import 'package:flutter/material.dart';

void showRatingTalkTooEarlyError(BuildContext context) {
  Scaffold.of(context).removeCurrentSnackBar();
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(
          "Talk can be rated 5 minutes before the presentation is finished."),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).accentColor,
    ),
  );
}
