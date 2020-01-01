import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';

import 'talk_card_widgets/animated_left_talk_container.dart';
import 'talk_card_widgets/favorite_button.dart';
import 'talk_card_widgets/room_indicator.dart';
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
                      right: 0,
                      top: compact ? 0 : null,
                      bottom: compact ? null : 0,
                      child: FavoriteButton(
                        isFavorite: isFavorite,
                        talk: talk,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: RoomIndicator(compact: compact, talk: talk),
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
          // border: Border.all(color: Colors.black26, width: 2),
          // boxShadow: [
          //   BoxShadow(
          //     blurRadius: 4,
          //     offset: Offset(2, 2),
          //     color: Colors.black.withOpacity(0.11),
          //   ),
          //   BoxShadow(
          //     blurRadius: 4,
          //     offset: Offset(-2, -2),
          //     color: Colors.white.withOpacity(0.93),
          //   )
          // ],
          ),
      child: Material(
        // color: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).cardColor,
        child: child,
      ),
    );
  }
}
