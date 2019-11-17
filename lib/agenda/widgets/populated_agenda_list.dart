import 'package:collection/collection.dart';
import 'package:conferenceapp/agenda/helpers/agenda_layout_helper.dart';
import 'package:conferenceapp/agenda/talk_card.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'animated_room_indicator.dart';
import 'animated_talk_date.dart';

class PopulatedAgendaDayList extends StatelessWidget {
  const PopulatedAgendaDayList(
    this.talksInDay, {
    Key key,
  }) : super(key: key);

  final List<Talk> talksInDay;

  @override
  Widget build(BuildContext context) {
    final talksPerHour = groupBy<Talk, DateTime>(talksInDay, (t) => t.dateTime);
    final rooms = talksInDay.map((f) => f.room).toSet().toList();

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
  }) : super(key: key);

  final Map<DateTime, List<Talk>> talksPerHour;
  final bool compact;
  final AgendaLayoutHelper layoutHelper;
  final AsyncSnapshot<List<Talk>> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 16.0,
      ),
      itemCount: talksPerHour.length,
      itemBuilder: (context, index) {
        final _talk = talksPerHour[talksPerHour.keys.toList()[index]].first;
        final _nextTalk =
            talksPerHour[talksPerHour.keys.toList()[index]].length > 1
                ? talksPerHour[talksPerHour.keys.toList()[index]][1]
                : null;

        final favoriteTalks = snapshot.data ?? [];

        return Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedTalkDate(compact: compact, talk: _talk),
              Flexible(
                child: Stack(
                  children: <Widget>[
                    if ((compact &&
                            layoutHelper.compactHeight(_talk, _nextTalk) !=
                                null) ||
                        (!compact &&
                            layoutHelper.normalHeight(_talk, _nextTalk) !=
                                null))
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                            height: compact
                                ? layoutHelper.compactHeight(_talk, _nextTalk)
                                : layoutHelper.normalHeight(_talk, _nextTalk),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                AnimatedPositioned(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeOut,
                                  top: 0,
                                  left: 0,
                                  bottom: compact
                                      ? layoutHelper
                                          .bottomPositionOfFirstTalkCardWhenCompact(
                                              _talk.id, _nextTalk?.id)
                                      : layoutHelper
                                          .bottomPositionOfFirstTalkCardWhenNormal(
                                              _talk.id, _nextTalk?.id),
                                  right: compact
                                      ? constraints.maxWidth / 2 + 5
                                      : 0,
                                  child: TalkCard(
                                    key: ValueKey(_talk.id),
                                    talk: _talk,
                                    isFavorite: favoriteTalks
                                        .any((t) => t.id == _talk.id),
                                    first: true,
                                    compact: compact,
                                  ),
                                ),
                                if (_nextTalk != null)
                                  AnimatedPositioned(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                    top: compact
                                        ? 0
                                        : layoutHelper
                                            .normalTalkHeight(_talk.id),
                                    left: compact
                                        ? constraints.maxWidth / 2 + 5
                                        : 0,
                                    right: 0,
                                    bottom: compact
                                        ? layoutHelper
                                            .bottomPositionOfSecondTalkCardWhenCompact(
                                                _talk.id, _nextTalk.id)
                                        : 0,
                                    child: TalkCard(
                                      key: ValueKey(_nextTalk.id),
                                      talk: _nextTalk,
                                      isFavorite: favoriteTalks
                                          .any((t) => t.id == _nextTalk.id),
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
