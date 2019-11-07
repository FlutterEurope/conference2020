import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:conferenceapp/agenda/talk_card.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/profile/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'day_selector.dart';

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
      child: Column(
        children: <Widget>[
          DaySelectorContainer(pageController, currentIndex.value),
          Flexible(
            child: PageView.builder(
              controller: pageController,
              itemCount: state.talks.length,
              itemBuilder: (context, index) {
                return new PopulatedAgendaDayList(state.talks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PopulatedAgendaDayList extends StatelessWidget {
  const PopulatedAgendaDayList(
    this.talks, {
    Key key,
  }) : super(key: key);

  final List<Talk> talks;

  @override
  Widget build(BuildContext context) {
    final favoritesRepository =
        RepositoryProvider.of<FavoritesRepository>(context);
    return StreamBuilder<List<Talk>>(
      stream: favoritesRepository.favoriteTalks,
      builder: (context, snapshot) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 16.0,
          ),
          itemCount: talks.length,
          itemBuilder: (context, index) {
            final _talk = talks[index];
            final isFirstInHour = _talk.dateTime.compareTo(
                    talks[index - 1 >= 0 ? index - 1 : 0]?.dateTime) !=
                0;
            final favoriteTalks = snapshot.data ?? [];
            final bool isFavorite = favoriteTalks.any((t) => t.id == _talk.id);
            return TalkCard(
              talk: _talk,
              isFavorite: isFavorite,
              first: isFirstInHour,
            );
          },
        );
      },
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
