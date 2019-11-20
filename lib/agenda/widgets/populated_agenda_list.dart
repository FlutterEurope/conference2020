import 'package:collection/collection.dart';
import 'package:conferenceapp/agenda/helpers/agenda_layout_helper.dart';
import 'package:conferenceapp/agenda/talk_card.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'animated_room_indicator.dart';
import 'animated_talk_date.dart';

class PopulatedAgendaDayList extends StatelessWidget {
  const PopulatedAgendaDayList(
    this.talksInDay,
    this.rooms, {
    Key key,
  }) : super(key: key);

  final List<Talk> talksInDay;
  final List<Room> rooms;

  @override
  Widget build(BuildContext context) {
    final talksPerHour = groupBy<Talk, DateTime>(talksInDay, (t) => t.dateTime);

    final favoritesRepository =
        RepositoryProvider.of<FavoritesRepository>(context);
    return StreamBuilder<List<Talk>>(
      stream: favoritesRepository.favoriteTalks,
      builder: (context, snapshot) {
        final layoutHelper = Provider.of<AgendaLayoutHelper>(context);
        final compact = layoutHelper.isCompact();
        final heightsCalculated = layoutHelper.hasHeightsCalculated();
        return Stack(
          children: <Widget>[
            if (heightsCalculated)
              PopulatedAgendaDayListContent(
                talksPerHour: talksPerHour,
                rooms: rooms,
                compact: compact,
                layoutHelper: layoutHelper,
                snapshot: snapshot,
              )
            else
              Center(child: CircularProgressIndicator()),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedRoomIndicator(
                compact: compact,
                rooms: rooms,
              ),
            ),
          ],
        );
      },
    );
  }
}

class PopulatedAgendaDayListContent extends StatelessWidget {
  const PopulatedAgendaDayListContent({
    Key key,
    @required this.talksPerHour,
    @required this.compact,
    @required this.layoutHelper,
    @required this.snapshot,
    @required this.rooms,
  }) : super(key: key);

  final Map<DateTime, List<Talk>> talksPerHour;
  final List<Room> rooms;
  final bool compact;
  final AgendaLayoutHelper layoutHelper;
  final AsyncSnapshot<List<Talk>> snapshot;

  @override
  Widget build(BuildContext context) {
    final hours = talksPerHour.keys.toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 16.0,
      ),
      itemCount: talksPerHour.length,
      itemBuilder: (context, index) {
        Talk _leftTalk;
        Talk _rightTalk;
        final thisHoursTalks = talksPerHour[hours[index]];
        //TODO make it independent of rooms number
        _leftTalk = thisHoursTalks.firstWhere((t) => t.room == rooms[0],
            orElse: () => null);
        _rightTalk = thisHoursTalks.firstWhere((t) => t.room == rooms[1],
            orElse: () => null);

        final favoriteTalks = snapshot.data ?? [];

        return Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedTalkDate(compact: compact, talk: _leftTalk ?? _rightTalk),
              Flexible(
                child: Stack(
                  children: <Widget>[
                    if ((compact &&
                            layoutHelper.compactHeight(_leftTalk, _rightTalk) !=
                                null) ||
                        (!compact &&
                            layoutHelper.normalHeight(_leftTalk, _rightTalk) !=
                                null))
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                            height: compact
                                ? layoutHelper.compactHeight(
                                    _leftTalk, _rightTalk)
                                : layoutHelper.normalHeight(
                                    _leftTalk, _rightTalk),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                if (_leftTalk != null)
                                  AnimatedPositioned(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                    top: 0,
                                    left: 0,
                                    bottom: compact
                                        ? layoutHelper
                                            .bottomPositionOfFirstTalkCardWhenCompact(
                                                _leftTalk?.id, _rightTalk?.id)
                                        : layoutHelper
                                            .bottomPositionOfFirstTalkCardWhenNormal(
                                                _leftTalk?.id, _rightTalk?.id),
                                    right: compact
                                        ? constraints.maxWidth / 2 + 5
                                        : 0,
                                    child: TalkCard(
                                      key: ValueKey(_leftTalk.id),
                                      talk: _leftTalk,
                                      isFavorite: favoriteTalks
                                          .any((t) => t.id == _leftTalk.id),
                                      first: true,
                                      compact: compact,
                                    ),
                                  ),
                                if (_rightTalk != null)
                                  AnimatedPositioned(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                    top: compact
                                        ? 0
                                        : layoutHelper
                                            .normalTalkHeight(_leftTalk?.id),
                                    left: compact
                                        ? constraints.maxWidth / 2 + 5
                                        : 0,
                                    right: 0,
                                    bottom: compact
                                        ? layoutHelper
                                            .bottomPositionOfSecondTalkCardWhenCompact(
                                                _leftTalk?.id, _rightTalk?.id)
                                        : 0,
                                    child: TalkCard(
                                      key: ValueKey(_rightTalk.id),
                                      talk: _rightTalk,
                                      isFavorite: favoriteTalks
                                          .any((t) => t.id == _rightTalk.id),
                                      first: false,
                                      compact: compact,
                                    ),
                                  )
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
