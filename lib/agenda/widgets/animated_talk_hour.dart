import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnimatedTalkHour extends StatelessWidget {
  const AnimatedTalkHour({
    Key key,
    @required this.compact,
    @required Talk talk,
  })  : _talk = talk,
        super(key: key);

  final bool compact;
  final Talk _talk;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 600),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation =
            Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                .animate(animation);
        return SizeTransition(
          sizeFactor: animation,
          axis: Axis.horizontal,
          child: FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: offsetAnimation,
              child: child,
            ),
          ),
        );
      },
      child: !compact
          ? Container()
          : CompactLeftTalkContainer(
              talk: _talk,
            ),
    );
  }
}

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
