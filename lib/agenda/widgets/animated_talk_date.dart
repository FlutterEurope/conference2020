import 'package:conferenceapp/agenda/talk_card.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';

class AnimatedTalkDate extends StatelessWidget {
  const AnimatedTalkDate({
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
