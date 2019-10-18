import 'package:flutter/material.dart';
import 'package:conferenceapp/agenda/agenda_page.dart';
import 'package:conferenceapp/bottom_navigation/bottom_bar_title.dart';
import 'package:conferenceapp/my_schedule/my_schedule_page.dart';
import 'package:conferenceapp/profile/profile_page.dart';
import 'package:flare_flutter/flare_actor.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: createBottomNavigation(),
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          AgendaPage(),
          MySchedulePage(),
          ProfilePage(),
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
            child: FlareActor(
              "assets/flare/tap_icon_agenda.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: _currentIndex == 0 ? "tap" : "idle",
            ),
          ),
          title: BottomBarTitle(
            title: 'Agenda',
            showTitle: _currentIndex != 0,
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: itemHeight,
            child: FlareActor(
              "assets/flare/tap_icon_agenda.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: _currentIndex == 1 ? "tap" : "idle",
            ),
          ),
          title: BottomBarTitle(
            title: 'My Schedule',
            showTitle: _currentIndex != 1,
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(
            height: itemHeight,
            child: FlareActor(
              "assets/flare/tap_icon_agenda.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: _currentIndex == 2 ? "tap" : "idle",
            ),
          ),
          title: BottomBarTitle(
            title: 'Profile',
            showTitle: _currentIndex != 2,
          ),
        ),
      ],
    );
  }
}
