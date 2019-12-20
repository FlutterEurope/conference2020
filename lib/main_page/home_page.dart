import 'dart:async';

import 'package:conferenceapp/agenda/agenda_page.dart';
import 'package:conferenceapp/analytics.dart';
import 'package:conferenceapp/bottom_navigation/bottom_bar_title.dart';
import 'package:conferenceapp/common/appbar.dart';
import 'package:conferenceapp/main_page/add_ticket_button.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/my_schedule/my_schedule_page.dart';
import 'package:conferenceapp/notifications/notifications_page.dart';
import 'package:conferenceapp/profile/profile_page.dart';
import 'package:conferenceapp/search/search_results_page.dart';
import 'package:conferenceapp/talk/talk_page.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const int agenda = 0;
  static const int mySchedule = 1;
  static const int notifications = 2;
  static const int profile = 3;

  final _tabs = {
    agenda: 'agenda',
    mySchedule: 'mySchedule',
    notifications: 'notifications',
    profile: 'profile',
  };

  @override
  void initState() {
    super.initState();
    //TODO: show only once
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: FlutterEuropeAppBar(
        onSearch: () {
          _showSearch(context);
        },
        layoutSelector: _currentIndex == agenda || _currentIndex == mySchedule,
      ),
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
    );
  }

  BottomNavigationBar createBottomNavigation() {
    final itemHeight = 40.0;
    final textSize = 12.0;

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        analytics.setCurrentScreen(
          screenName: '/home/${_tabs[index]}',
        );
        setState(() {
          _currentIndex = index;
        });
      },
      unselectedItemColor: Theme.of(context).brightness == Brightness.light
          ? Theme.of(context).bottomAppBarTheme.color
          : Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: textSize,
      unselectedFontSize: textSize,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            height: itemHeight,
            child: Icon(LineIcons.calendar),
          ),
          title: BottomBarTitle(
            title: 'Agenda',
            showTitle: _currentIndex != agenda,
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: itemHeight,
            child: Icon(LineIcons.calendar_check_o),
          ),
          title: BottomBarTitle(
            title: 'My Schedule',
            showTitle: _currentIndex != mySchedule,
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: itemHeight,
            child: Icon(LineIcons.bell),
          ),
          title: BottomBarTitle(
            title: 'Notifications',
            showTitle: _currentIndex != notifications,
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: itemHeight,
            child: Icon(LineIcons.user),
          ),
          title: BottomBarTitle(
            title: 'Profile',
            showTitle: _currentIndex != profile,
          ),
        ),
      ],
    );
  }

  _showSearch(BuildContext context) async {
    try {
      final res =
          await Navigator.push<Talk>(context, _buildSearchPage(context));
      if (res != null) {
        analytics.logEvent(
          name: 'search_completed',
          parameters: {
            'selected_talk_id': res.id,
            'selected_talk': '$res',
          },
        );
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TalkPage(res.id),
            settings: RouteSettings(name: 'agenda/${res.id}'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  _buildSearchPage(BuildContext context) {
    return MaterialPageRoute<Talk>(
      settings: RouteSettings(
        name: 'search',
        isInitialRoute: false,
      ),
      builder: (BuildContext context) => SearchResultsPage(),
    );
  }
}
