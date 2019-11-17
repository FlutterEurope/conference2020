import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:conferenceapp/agenda/day_selector.dart';
import 'package:conferenceapp/agenda/helpers/agenda_layout_helper.dart';
import 'package:conferenceapp/agenda/helpers/widget_to_calculate_heights_of_talks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'populated_agenda_list.dart';

class PopulatedAgendaTable extends StatelessWidget {
  PopulatedAgendaTable(
    this.state,
    this.pageController,
    this.currentIndex, {
    Key key,
  }) : super(key: key);

  final PopulatedAgendaState state;
  final PageController pageController;
  final ValueNotifier<int> currentIndex;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Stack(
        children: <Widget>[
          // We need to calculate sizes of the talk cards before animating them
          if (Provider.of<AgendaLayoutHelper>(context).hasHeightsCalculated() ==
              false)
            WidgetUsedToCalculateHeightsOfTalkCards(talks: state.talks),
          Column(
            children: <Widget>[
              DaySelectorContainer(pageController, currentIndex.value),
              Flexible(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: state.talks.length,
                  itemBuilder: (context, index) {
                    return PopulatedAgendaDayList(state.talks[index]);
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
