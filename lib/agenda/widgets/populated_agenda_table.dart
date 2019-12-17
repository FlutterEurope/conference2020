import 'package:conferenceapp/agenda/day_selector.dart';
import 'package:conferenceapp/agenda/helpers/agenda_layout_helper.dart';
import 'package:conferenceapp/agenda/helpers/widget_to_calculate_heights_of_talks.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'populated_agenda_list.dart';

class PopulatedAgendaTable extends StatelessWidget {
  PopulatedAgendaTable(
    this.talks,
    this.rooms,
    this.pageController,
    this.currentIndex, {
    this.skipWidgetPreload = false,
    Key key,
  }) : super(key: key);

  final Map<int, List<Talk>> talks;
  final List<Room> rooms;
  final PageController pageController;
  final ValueNotifier<int> currentIndex;
  final bool skipWidgetPreload;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(
        children: <Widget>[
          // We need to calculate sizes of the talk cards before animating them
          if (Provider.of<AgendaLayoutHelper>(context).hasHeightsCalculated() ==
                  false &&
              !skipWidgetPreload)
            WidgetUsedToCalculateHeightsOfTalkCards(talks: talks),
          Column(
            children: <Widget>[
              DaySelectorContainer(pageController, currentIndex.value),
              Flexible(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: talks.length,
                  itemBuilder: (context, index) {
                    return PopulatedAgendaDayList(talks[index], rooms);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
