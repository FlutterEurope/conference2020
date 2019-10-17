import 'package:conferenceapp/agenda/talk_card.dart';
import 'package:conferenceapp/model/speaker.dart';
import 'package:flutter/material.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 16.0,
        ),
        //TODO: replace with builder
        children: <Widget>[
          Hours('9:00', '9:45'),
          TalkCard(
            speakers: [
              Speaker('John Nowak', ''),
              Speaker('Stacey Kovalsky', ''),
            ],
            room: 'A',
            color: Colors.blue,
            level: 2,
            isFavorite: false,
            title: 'Why should you consider Flutter',
          ),
          SizedBox(height: 16.0),
          TalkCard(
            speakers: [
              Speaker('John Nowak', ''),
              Speaker('Stacey Kovalsky', ''),
            ],
            room: 'B',
            color: Colors.deepOrange,
            level: 3,
            isFavorite: true,
            title: 'Sample long title of the next talk on this conference',
          ),
          Hours('10:00', '10:45'),
          TalkCard(
            speakers: [
              Speaker('Stacey Kovalsky', ''),
            ],
            room: 'A',
            color: Colors.blue,
            level: 2,
            isFavorite: false,
            title: 'Why should you consider Flutter for your next app',
          ),
          SizedBox(height: 16.0),
          TalkCard(
            speakers: [
              Speaker('John Nowak', ''),
            ],
            room: 'B',
            color: Colors.deepOrange,
            level: 3,
            isFavorite: true,
            title: 'Sample short title',
          ),
        ],
      ),
    );
  }
}

class Hours extends StatelessWidget {
  const Hours(
    this.start,
    this.stop, {
    Key key,
  }) : super(key: key);
  final String start;
  final String stop;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text('$start - $stop'),
      ),
    );
  }
}
