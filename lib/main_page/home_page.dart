import 'package:conferenceapp/agenda/agenda_page.dart';
import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:conferenceapp/agenda/repository/talks_repository.dart';
import 'package:conferenceapp/bottom_navigation/bottom_bar_title.dart';
import 'package:conferenceapp/common/appbar.dart';
import 'package:conferenceapp/main_page/add_ticket_button.dart';
import 'package:conferenceapp/my_schedule/my_schedule_page.dart';
import 'package:conferenceapp/notifications/notifications_page.dart';
import 'package:conferenceapp/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => AgendaBloc(RepositoryProvider.of<TalkRepository>(context))..add(InitAgenda()),
      child: Scaffold(
        appBar: FlutterEuropeAppBar(),
        bottomNavigationBar: createBottomNavigation(),
        body: Stack(
          children: <Widget>[
            IndexedStack(
              index: _currentIndex,
              children: <Widget>[
                AgendaPage(),
                MySchedulePage(),
                NotificationsPage(),
                ProfilePage(),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AddTicketButton(),
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBar createBottomNavigation() {
    final itemHeight = 40.0;
    final textSize = 12.0;

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedFontSize: textSize,
      unselectedFontSize: textSize,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            height: itemHeight,
            child: Icon(LineIcons.calendar),

            // child: FlareActor(
            //   "assets/flare/tap_icon_agenda.flr",
            //   alignment: Alignment.center,
            //   fit: BoxFit.contain,
            //   animation: _currentIndex == 0 ? "tap" : "idle",
            // ),
          ),
          title: BottomBarTitle(
            title: 'Agenda',
            showTitle: _currentIndex != 0,
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: itemHeight,
            child: Icon(LineIcons.calendar_check_o),
          ),
          title: BottomBarTitle(
            title: 'My Schedule',
            showTitle: _currentIndex != 1,
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: itemHeight,
            child: Icon(LineIcons.bell),
          ),
          title: BottomBarTitle(
            title: 'Notifications',
            showTitle: _currentIndex != 2,
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: itemHeight,
            child: Icon(LineIcons.user),
          ),
          title: BottomBarTitle(
            title: 'Profile',
            showTitle: _currentIndex != 3,
          ),
        ),
      ],
    );
  }
}
