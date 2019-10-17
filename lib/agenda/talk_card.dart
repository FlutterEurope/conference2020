import 'package:conferenceapp/model/speaker.dart';
import 'package:flutter/material.dart';

class TalkCard extends StatelessWidget {
  const TalkCard({
    Key key,
    this.title,
    this.speakers,
    this.room,
    this.color,
    this.level,
    this.isFavorite,
  }) : super(key: key);

  final List<Speaker> speakers;
  final String room;
  final Color color;
  final String title;
  final int level;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 30,
                offset: Offset(0, 10),
                color: Colors.black26,
                spreadRadius: -10,
              )
            ],
            color: Colors.white,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 20,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TalkTitle(title: title),
                    ),
                    SizedBox(height: 12),
                    for (var speaker in speakers) TalkSpeaker(speaker: speaker),
                    SizedBox(height: 8),
                    TalkBottomInfo(level, isFavorite)
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Triangle(
                  room,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TalkBottomInfo extends StatelessWidget {
  const TalkBottomInfo(
    this.level,
    this.isFavorite, {
    Key key,
  }) : super(key: key);

  final int level;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < level; i++) FlutterLogo(),
        Spacer(),
        Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        )
      ],
    );
  }
}

class TalkSpeaker extends StatelessWidget {
  const TalkSpeaker({
    Key key,
    @required this.speaker,
  }) : super(key: key);

  final Speaker speaker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 14,
          ),
          SizedBox(width: 10),
          Flexible(
            child: Text(
              speaker.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
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
        fontSize: 22,
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

  final String room;
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
              room,
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
