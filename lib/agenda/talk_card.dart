import 'package:conferenceapp/model/author.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TalkCard extends StatelessWidget {
  const TalkCard({
    Key key,
    this.talk,
    this.isFavorite,
    this.first,
    this.compact = false,
    this.onTap,
  }) : super(key: key);

  final Talk talk;
  final bool isFavorite;
  final bool first;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const topPadding = 16.0;

    return Padding(
      padding: EdgeInsets.only(top: first || compact ? 16.0 : 4.0),
      child: TalkCardDecoration(
        child: InkWell(
          onTap: onTap,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedLeftTalkContainer(
                compact: compact,
                talk: talk,
                topPadding: topPadding,
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
                      child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 18.0),
                                      child: TalkTitle(
                                        title: talk.title,
                                        compact: compact,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                  child: SizedBox(
                                      height: talk.authors.length * 28.0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: topPadding, left: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            for (var speaker in talk.authors)
                              TalkSpeaker(speaker: speaker, compact: compact),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: compact ? 0 : 1,
                          child: Triangle(
                            talk.room,
                            color: talk.room.name == 'A'
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).accentColor,
                          ),
                        )),
                    AnimatedAlign(
                      duration: Duration(milliseconds: 300),
                      alignment:
                          compact ? Alignment.topRight : Alignment.bottomRight,
                      child: FavoriteButton(
                        isFavorite: isFavorite,
                        talkId: talk.id,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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

class TalkCardDecoration extends StatelessWidget {
  const TalkCardDecoration({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            offset: Offset(0, 10),
            color: Colors.black.withOpacity(0.1),
            spreadRadius: -10,
          )
        ],
      ),
      child: Material(
        color: Theme.of(context).cardColor,
        child: child,
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    Key key,
    @required this.isFavorite,
    @required this.talkId,
  }) : super(key: key);

  final bool isFavorite;

  final String talkId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onPressed(context),
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  void _onPressed(BuildContext context) {
    final favoritesRepo = RepositoryProvider.of<FavoritesRepository>(context);
    if (isFavorite) {
      favoritesRepo.removeTalkFromFavorites(talkId);
    } else {
      favoritesRepo.addTalkToFavorites(talkId);
    }
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
              hourFormat.format(talk.dateTime),
              style: hourStyle,
            ),
            SizedBox(height: 2),
            Text(
              hourFormat.format(talk.dateTime.add(talk.duration)),
              style: hourStyle,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < talk.level; i++) FlutterLogo(size: 12),
              ],
            )
          ],
        ),
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
              hourFormat.format(talk.dateTime),
              style: hourStyle,
            ),
            SizedBox(height: 2),
            Text(
              hourFormat.format(talk.dateTime.add(talk.duration)),
              style: hourStyle,
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
    this.compact = false,
  }) : super(key: key);

  final Author speaker;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            key: ValueKey(speaker.avatar),
            radius: 10,
            backgroundImage: ExtendedNetworkImageProvider(
              speaker.avatar,
              cache: true,
            ),
          ),
          SizedBox(width: compact ? 5 : 10),
          Flexible(
            child: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 400),
              style: compact
                  ? Theme.of(context).textTheme.body2.copyWith(fontSize: 12)
                  : Theme.of(context).textTheme.body2.copyWith(fontSize: 14),
              child: Text(
                speaker.fullName,
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
    @required this.compact,
  }) : super(key: key);

  final String title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: Duration(milliseconds: 400),
      style: compact
          ? Theme.of(context)
              .textTheme
              .body2
              .copyWith(fontSize: 16, fontWeight: FontWeight.w400)
          : Theme.of(context)
              .textTheme
              .body2
              .copyWith(fontSize: 20, fontWeight: FontWeight.w400),
      child: Text(
        title,
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
