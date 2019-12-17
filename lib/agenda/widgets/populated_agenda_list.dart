import 'package:collection/collection.dart';
import 'package:conferenceapp/agenda/helpers/agenda_layout_helper.dart';
import 'package:conferenceapp/agenda/widgets/talk_card.dart';
import 'package:conferenceapp/model/agenda.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:conferenceapp/talk/talk_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'animated_room_indicator.dart';
import 'animated_talk_hour.dart';

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
    final talksPerHour =
        groupBy<Talk, DateTime>(talksInDay, (t) => t.startTime);

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

    if (hours.isEmpty) {
      return Center(
        child: Text('No talks on this day'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 16.0,
      ),
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: talksPerHour.length,
      itemBuilder: (context, index) {
        Talk _firstTalk;
        Talk _secondTalk;

        final _thisHoursTalks = talksPerHour[hours[index]];
        //TODO: make it independent of rooms number
        _firstTalk = _thisHoursTalks.firstWhere(
            (t) => t.room.id != TalkType.advanced.toString(),
            orElse: () => null);
        _secondTalk = _thisHoursTalks.firstWhere(
            (t) => t.room.id == TalkType.advanced.toString(),
            orElse: () => null);

        final favoriteTalks = snapshot.data ?? [];

        return Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AnimatedTalkHour(
                  compact: compact, talk: _firstTalk ?? _secondTalk),
              Flexible(
                child: Stack(
                  children: <Widget>[
                    if ((compact &&
                            layoutHelper.compactHeight(
                                    _firstTalk, _secondTalk) !=
                                null) ||
                        (!compact &&
                            layoutHelper.normalHeight(
                                    _firstTalk, _secondTalk) !=
                                null))
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // final animator = Animator(
                          //   duration: const Duration(milliseconds: 500),
                          //   resetAnimationOnRebuild: true,
                          //   tweenMap: {
                          //     "firstBottom": Tween<double>(
                          //       begin: layoutHelper
                          //           .bottomPositionOfFirstTalkCardWhenCompact(
                          //               _firstTalk?.id, _secondTalk?.id),
                          //       end: layoutHelper
                          //           .bottomPositionOfFirstTalkCardWhenNormal(
                          //               _firstTalk?.id, _secondTalk?.id),
                          //     ),
                          //     "firstRight": Tween<double>(
                          //       begin: constraints.maxWidth / 2 + 5,
                          //       end: 0,
                          //     ),
                          //     "secondTop": Tween<double>(
                          //       begin: 0,
                          //       end: layoutHelper
                          //           .normalTalkHeight(_firstTalk?.id),
                          //     ),
                          //     "secondLeft": Tween<double>(
                          //       begin: constraints.maxWidth / 2 + 5,
                          //       end: 0,
                          //     ),
                          //     "secondBottom": Tween<double>(
                          //       begin: layoutHelper
                          //           .bottomPositionOfSecondTalkCardWhenCompact(
                          //               _firstTalk?.id, _secondTalk?.id),
                          //       end: 0,
                          //     )
                          //   },
                          //   builderMap: (anim) => AnimatedContainer(
                          //     duration: Duration(milliseconds: 400),
                          //     curve: Curves.easeOut,
                          //     height: compact
                          //         ? layoutHelper.compactHeight(
                          //             _firstTalk, _secondTalk)
                          //         : layoutHelper.normalHeight(
                          //             _firstTalk, _secondTalk),
                          //     child: Stack(
                          //       fit: StackFit.expand,
                          //       children: <Widget>[
                          //         if (_firstTalk != null)
                          //           Positioned(
                          //             top: 0,
                          //             left: 0,
                          //             bottom: anim['firstBottom'].value,
                          //             right: anim['firstRight'].value,
                          //             child: TalkCard(
                          //               key: ValueKey(_firstTalk.id),
                          //               talk: _firstTalk,
                          //               isFavorite: favoriteTalks
                          //                   .any((t) => t.id == _firstTalk.id),
                          //               first: true,
                          //               compact: compact,
                          //               onTap: () => onTap(context, _firstTalk),
                          //             ),
                          //           ),
                          //         if (_secondTalk != null)
                          //           Positioned(
                          //             top: anim['secondTop'].value,
                          //             left: anim['secondLeft'].value,
                          //             right: 0,
                          //             bottom: anim['secondBottom'].value,
                          //             child: TalkCard(
                          //               key: ValueKey(_secondTalk.id),
                          //               talk: _secondTalk,
                          //               isFavorite: favoriteTalks
                          //                   .any((t) => t.id == _secondTalk.id),
                          //               first: false,
                          //               compact: compact,
                          //               onTap: () =>
                          //                   onTap(context, _secondTalk),
                          //             ),
                          //           )
                          //       ],
                          //     ),
                          //   ),
                          // );
                          //
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeOut,
                            height: compact
                                ? layoutHelper.compactHeight(
                                    _firstTalk, _secondTalk)
                                : layoutHelper.normalHeight(
                                    _firstTalk, _secondTalk),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                if (_firstTalk != null)
                                  AnimatedPositioned(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                    top: 0,
                                    left: 0,
                                    bottom: compact
                                        ? layoutHelper
                                            .bottomPositionOfFirstTalkCardWhenCompact(
                                                _firstTalk?.id, _secondTalk?.id)
                                        : layoutHelper
                                            .bottomPositionOfFirstTalkCardWhenNormal(
                                                _firstTalk?.id,
                                                _secondTalk?.id),
                                    right: compact
                                        ? constraints.maxWidth / 2 + 5
                                        : 0,
                                    child: TalkCard(
                                      key: ValueKey(_firstTalk.id),
                                      talk: _firstTalk,
                                      isFavorite: favoriteTalks
                                          .any((t) => t.id == _firstTalk.id),
                                      first: true,
                                      compact: compact,
                                      onTap: () => onTap(context, _firstTalk),
                                    ),
                                  ),
                                if (_secondTalk != null)
                                  AnimatedPositioned(
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                    top: compact
                                        ? 0
                                        : layoutHelper
                                            .normalTalkHeight(_firstTalk?.id),
                                    left: compact
                                        ? constraints.maxWidth / 2 + 5
                                        : 0,
                                    right: 0,
                                    bottom: compact
                                        ? layoutHelper
                                            .bottomPositionOfSecondTalkCardWhenCompact(
                                                _firstTalk?.id, _secondTalk?.id)
                                        : 0,
                                    child: TalkCard(
                                      key: ValueKey(_secondTalk.id),
                                      talk: _secondTalk,
                                      isFavorite: favoriteTalks
                                          .any((t) => t.id == _secondTalk.id),
                                      first: false,
                                      compact: compact,
                                      onTap: () => onTap(context, _secondTalk),
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

  void onTap(BuildContext context, Talk talk) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TalkPage(talk.id),
        settings: RouteSettings(name: 'agenda/${talk.id}'),
      ),
    );
  }
}
