import 'dart:math' as math;
import 'package:conferenceapp/model/agenda.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';

class RoomIndicator extends StatelessWidget {
  const RoomIndicator({
    Key key,
    @required this.compact,
    @required this.talk,
  }) : super(key: key);

  final bool compact;
  final Talk talk;

  @override
  Widget build(BuildContext context) {
    if (talk == null) return Container();
    return Visibility(
      visible: !compact,
      child: _Triangle(
        talk.room,
        color: talk.room.id == TalkType.beginner.toString()
            ? Theme.of(context).primaryColor
            : Theme.of(context).accentColor,
      ),
    );
  }
}

class _Triangle extends StatelessWidget {
  const _Triangle(
    this.room, {
    Key key,
    this.color,
  }) : super(key: key);

  final Room room;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ShapesPainter(color),
      child: Container(
        height: 50,
        width: 50,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 16),
            child: Transform.rotate(
              angle: math.pi / 4,
              child: Text(
                room.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShapesPainter extends CustomPainter {
  final Color color;

  _ShapesPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
