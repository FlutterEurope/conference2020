import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';

import 'talk_card_widgets/animated_left_talk_container.dart';
import 'talk_card_widgets/favorite_button.dart';
import 'talk_card_widgets/room_indicator.dart';
import 'talk_card_widgets/speakers.dart';
import 'talk_card_widgets/talk_title.dart';

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
                    TitleWrapper(
                        topPadding: topPadding, talk: talk, compact: compact),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Speakers(
                          topPadding: topPadding, talk: talk, compact: compact),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: RoomIndicator(compact: compact, talk: talk),
                    ),
                    AnimatedAlign(
                      duration: Duration(milliseconds: 300),
                      alignment:
                          compact ? Alignment.topRight : Alignment.bottomRight,
                      child: FavoriteButton(
                        isFavorite: isFavorite,
                        talkId: talk?.id,
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
