import 'package:conferenceapp/model/agenda.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:flutter/material.dart';

class AnimatedRoomIndicator extends StatelessWidget {
  const AnimatedRoomIndicator({
    Key key,
    @required this.compact,
    @required this.rooms,
  }) : super(key: key);

  final bool compact;
  final List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black54
        : Colors.grey[100];
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 600),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation =
            Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                .animate(animation);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: !compact
          ? SizedBox()
          : Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 36),
                    Expanded(
                      child: Center(
                        child: Text(
                          rooms
                              .firstWhere(
                                  (t) => t.id == TalkType.beginner.toString())
                              .name,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          rooms
                              .firstWhere(
                                  (t) => t.id == TalkType.advanced.toString())
                              .name,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
