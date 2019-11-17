import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/loading_agenda_table.dart';
import 'widgets/populated_agenda_table.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({
    Key key,
  }) : super(key: key);

  @override
  _AgendaPageState createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  PageController pageController;
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    pageController.addListener(() {
      if (pageController.page.round() != currentIndex.value) {
        currentIndex.value = pageController.page.round();
      }
    });
    currentIndex.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AgendaBloc>(context),
      builder: (context, AgendaState state) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          state is PopulatedAgendaState
              ? PopulatedAgendaTable(state, pageController, currentIndex)
              : LoadingAgendaTable(),
        ],
      ),
    );
  }
}
