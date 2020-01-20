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
    if (talk == null) return Container();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var speaker in talk.authors)
          _TalkSpeaker(speaker: speaker, compact: compact),
        if (talk.authors.isEmpty) SizedBox(height: 24)
      ],
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
          if (speaker.avatar != null)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: ExtendedNetworkImageProvider(
                    speaker.avatar + '?fit=fill&w=50&h=50',
                    cache: true
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SizedBox(width: compact ? 5 : 10),
          Flexible(
            child: Text(
              speaker.name,
              style: TextStyle(fontSize: compact ? 12 : 14),
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
    if (talk == null) return SizedBox(height: 22.0);

    return SizedBox(
        height: talk.authors.isEmpty ? 22.0 : talk.authors.length * 28.0);
  }
}
