import 'package:conferenceapp/model/author.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class Speakers extends StatelessWidget {
  const Speakers({
    Key key,
    @required this.topPadding,
    @required this.talk,
    @required this.compact,
  }) : super(key: key);

  final double topPadding;
  final Talk talk;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: topPadding, left: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (var speaker in talk.authors)
            _TalkSpeaker(speaker: speaker, compact: compact),
        ],
      ),
    );
  }
}

class _TalkSpeaker extends StatelessWidget {
  const _TalkSpeaker({
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
            backgroundImage: speaker.avatar != null
                ? ExtendedNetworkImageProvider(
                    speaker.avatar,
                    cache: true,
                  )
                : null,
          ),
          SizedBox(width: compact ? 5 : 10),
          Flexible(
            child: AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 400),
              style: compact
                  ? Theme.of(context).textTheme.body2.copyWith(fontSize: 12)
                  : Theme.of(context).textTheme.body2.copyWith(fontSize: 14),
              child: Text(
                speaker.name,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SpeakersHeightEquivalent extends StatelessWidget {
  const SpeakersHeightEquivalent({
    Key key,
    @required this.talk,
  }) : super(key: key);

  final Talk talk;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: talk.authors.isEmpty ? 22.0 : talk.authors.length * 28.0);
  }
}
