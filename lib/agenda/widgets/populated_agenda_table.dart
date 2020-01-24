import 'dart:async';

import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:conferenceapp/model/room.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'populated_agenda_list.dart';

class PopulatedAgendaTable extends StatefulWidget {
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
  _PopulatedAgendaTableState createState() => _PopulatedAgendaTableState();
}

class _PopulatedAgendaTableState extends State<PopulatedAgendaTable> {
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AgendaBloc, AgendaState>(
      listener: (context, state) {
        if (state is PopulatedAgendaState) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      child: PageView(
        controller: widget.pageController,
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: <Widget>[
          RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<AgendaBloc>(context).add(FetchAgenda());
              return _refreshCompleter.future;
            },
            child: widget.talks[0] != null
                ? PopulatedAgendaDayList(widget.talks[0], widget.rooms)
                : EmptyPopulated(),
          ),
          RefreshIndicator(
            onRefresh: () async {
              BlocProvider.of<AgendaBloc>(context).add(FetchAgenda());
              return _refreshCompleter.future;
            },
            child: widget.talks[1] != null
                ? PopulatedAgendaDayList(widget.talks[1], widget.rooms)
                : EmptyPopulated(),
          ),
        ],
      ),
    );
  }
}

class EmptyPopulated extends StatelessWidget {
  const EmptyPopulated({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Image.asset('assets/404.png'),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Seems like we have a connection problem. Try to restart the app.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
