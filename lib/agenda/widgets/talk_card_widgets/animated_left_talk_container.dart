import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnimatedLeftTalkContainer extends StatelessWidget {
  const AnimatedLeftTalkContainer({
    Key key,
    @required this.compact,
    @required this.talk,
    @required this.topPadding,
  }) : super(key: key);

  final bool compact;
  final Talk talk;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation =
            Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
                .animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: SlideTransition(
              position: offsetAnimation,
              child: child,
            ),
          ),
        );
      },
      child: compact
          ? Container()
          : LeftTalkContainer(
              talk: talk,
              topPadding: topPadding,
            ),
    );
  }
}

class LeftTalkContainer extends StatelessWidget {
  const LeftTalkContainer({
    Key key,
    @required this.topPadding,
    @required this.talk,
  }) : super(key: key);

  final double topPadding;
  final Talk talk;

  @override
  Widget build(BuildContext context) {
    if (talk == null) return Container();

    final hourFormat = DateFormat.Hm();
    final hourStyle = TextStyle(
      fontSize: 16,
      color: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColorLight,
    );
    return Padding(
      padding: EdgeInsets.only(top: topPadding + 2, left: 12.0),
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
