import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:conferenceapp/agenda/talk_card.dart';
import 'package:conferenceapp/model/mock_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'day_selector.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AgendaBloc>(context),
      builder: (context, AgendaState state) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DaySelectorContainer(),
          state is PopulatedAgendaState
              ? PopulatedAgendaTable(state)
              : LoadingAgendaTable(),
        ],
      ),
    );
  }
}

class LoadingAgendaTable extends StatelessWidget {
  const LoadingAgendaTable({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class PopulatedAgendaTable extends StatelessWidget {
  const PopulatedAgendaTable(
    this.state, {
    Key key,
  }) : super(key: key);
  final PopulatedAgendaState state;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 16.0,
        ),
        itemCount: state.talks.length,
        itemBuilder: (context, index) {
          final _talk = state.talks[index];
          final isFirstInHour = _talk.dateTime.compareTo(
                  state.talks[index - 1 >= 0 ? index - 1 : 0]?.dateTime) !=
              0;
          return TalkCard(
            talk: _talk,
            isFavorite: false,
            first: isFirstInHour,
          );
        },
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
