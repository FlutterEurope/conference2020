import 'package:conferenceapp/agenda/day_selector.dart';
import 'package:conferenceapp/agenda/helpers/agenda_layout_helper.dart';
import 'package:conferenceapp/agenda/helpers/widget_to_calculate_heights_of_talks.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/notifications/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'populated_agenda_list.dart';

class PopulatedAgendaTable extends StatelessWidget {
  const PopulatedAgendaTable(
    this.talks,
    this.rooms,
    this.pageController, {
    this.skipWidgetPreload = false,
    Key key,
  }) : super(key: key);

  final Map<int, List<Talk>> talks;
  final List<Room> rooms;
  final PageController pageController;
  final bool skipWidgetPreload;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: <Widget>[
        PopulatedAgendaDayList(talks[0], rooms),
        PopulatedAgendaDayList(talks[1], rooms),
      ],
    );
  }
}
