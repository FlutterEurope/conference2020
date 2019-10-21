import 'package:conferenceapp/model/author.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TalkCard extends StatelessWidget {
  const TalkCard({
    Key key,
    this.talk,
    this.isFavorite,
    this.first,
  }) : super(key: key);

  final Talk talk;
  final bool isFavorite;
  final bool first;

  @override
  Widget build(BuildContext context) {
    final hourFormat = DateFormat.Hm();
    const topPadding = 12.0;
    final hourStyle = TextStyle(
      fontSize: 16,
      color: Theme.of(context).primaryColor,
    );
    return Padding(
      padding: EdgeInsets.only(top: first ? 16.0 : 4.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 30,
              offset: Offset(0, 10),
              color: Colors.black.withOpacity(0.1),
              spreadRadius: -10,
            )
          ],
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: topPadding + 2, left: 12.0),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      hourFormat.format(talk.dateTime),
                      style: hourStyle,
                    ),
                    SizedBox(height: 4),
                    Text(
                      hourFormat.format(talk.dateTime.add(talk.duration)),
                      style: hourStyle,
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        for (int i = 0; i < talk.level; i++)
                          FlutterLogo(size: 12),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: topPadding,
                      bottom: topPadding,
                      left: 16,
                      right: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TalkTitle(title: talk.title),
                        ),
                        SizedBox(height: 8.0),
                        for (var speaker in talk.authors)
                          TalkSpeaker(speaker: speaker),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Triangle(
                      talk.room,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TalkSpeaker extends StatelessWidget {
  const TalkSpeaker({
    Key key,
    @required this.speaker,
  }) : super(key: key);

  final Author speaker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(speaker.avatar),
          ),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              speaker.fullName,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TalkTitle extends StatelessWidget {
  const TalkTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 20,
      ),
    );
  }
}

class Triangle extends StatelessWidget {
  const Triangle(
    this.room, {
    Key key,
    this.color,
  }) : super(key: key);

  final Room room;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ShapesPainter(color),
      child: Container(
        height: 50,
        width: 50,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 16),
            child: Text(
              room.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShapesPainter extends CustomPainter {
  final Color color;

  ShapesPainter(this.color);
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
