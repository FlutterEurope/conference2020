import 'package:conferenceapp/agenda/agenda_page.dart';
import 'package:conferenceapp/agenda/bloc/bloc.dart';
import 'package:conferenceapp/agenda/repository/talks_repository.dart';
import 'package:conferenceapp/bottom_navigation/bottom_bar_title.dart';
import 'package:conferenceapp/my_schedule/my_schedule_page.dart';
import 'package:conferenceapp/notifications/notifications_page.dart';
import 'package:conferenceapp/profile/profile_page.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import 'account_avatar.dart';

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
      builder: (context) => AgendaBloc(MockTalksRepository())..add(InitAgenda()),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            Theme.of(context).brightness == Brightness.light
                ? 'assets/logo_negative.png'
                : 'assets/logo_negative_dark.png',
            height: 48,
          ),
          elevation: 0,
          leading: AccountAvatar(),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        bottomNavigationBar: createBottomNavigation(),
        body: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            AgendaPage(),
            MySchedulePage(),
            NotificationsPage(),
            ProfilePage(),
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
