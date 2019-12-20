import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompactLeftTalkContainer extends StatelessWidget {
  const CompactLeftTalkContainer({
    Key key,
    @required this.talk,
  }) : super(key: key);

  final Talk talk;

  @override
  Widget build(BuildContext context) {
    final hourFormat = DateFormat.Hm();
    final hourStyle = TextStyle(
      fontSize: 12,
      color: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColorLight,
    );
    return Padding(
      padding: EdgeInsets.only(top: 16.0, right: 6.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              hourFormat.format(talk.startTime),
              style: hourStyle,
            ),
            SizedBox(height: 2),
            Text(
              hourFormat.format(talk.endTime),
              style: hourStyle,
            ),
          ],
        ),
      ),
    );
  }
}
