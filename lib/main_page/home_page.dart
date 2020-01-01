import 'package:conferenceapp/admin/admin_page.dart';
import 'package:conferenceapp/agenda/agenda_page.dart';
import 'package:conferenceapp/analytics.dart';
import 'package:conferenceapp/bottom_navigation/bottom_bar_title.dart';
import 'package:conferenceapp/common/appbar.dart';
import 'package:conferenceapp/main_page/add_ticket_button.dart';
import 'package:conferenceapp/main_page/learn_features_button.dart';
import 'package:conferenceapp/model/talk.dart';
import 'package:conferenceapp/my_schedule/my_schedule_page.dart';
import 'package:conferenceapp/notifications/notifications_page.dart';
import 'package:conferenceapp/notifications/repository/notifications_unread_repository.dart';
import 'package:conferenceapp/profile/auth_repository.dart';
import 'package:conferenceapp/profile/profile_page.dart';
import 'package:conferenceapp/search/search_results_page.dart';
import 'package:conferenceapp/talk/talk_page.dart';
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

  static const int agenda = 0;
  static const int mySchedule = 1;
  static const int notifications = 2;
  static const int profile = 3;
  static const int admin = 4;

  final _tabs = {
    agenda: 'agenda',
    mySchedule: 'mySchedule',
    notifications: 'notifications',
    profile: 'profile',
    admin: 'admin',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: RepositoryProvider.of<AuthRepository>(context).isAdmin,
        builder: (context, snapshot) {
          final isAdmin = snapshot.data == true;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: FlutterEuropeAppBar(
              onSearch: () {
                _showSearch(context);
              },
              layoutSelector:
                  _currentIndex == agenda || _currentIndex == mySchedule,
            ),
            bottomNavigationBar: createBottomNavigation(isAdmin),
            body: Stack(
              children: <Widget>[
                IndexedStack(
                  index: _adminAwareIndex(_currentIndex, isAdmin),
                  children: <Widget>[
                    AgendaPage(),
                    MySchedulePage(),
                    NotificationsPage(),
                    ProfilePage(),
                    if (isAdmin) AdminPage() else Container(),
                  ],
                ),
                Visibility(
                  visible: _currentIndex != notifications,
                  child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AddTicketButton(),
                  ),
                ),
                Visibility(
                  visible:
                      _currentIndex == agenda || _currentIndex == mySchedule,
                  child: Positioned(
                    bottom: 0,
                    right: 0,
                    child: LearnFeaturesButton(),
                  ),
                )
              ],
            ),
          );
        });
  }

  BottomNavigationBar createBottomNavigation([bool isAdmin = false]) {
    final itemHeight = 40.0;
    final textSize = 12.0;

    return BottomNavigationBar(
      // if admin logs out we can't remain on admin page
      currentIndex: _adminAwareIndex(_currentIndex, isAdmin),
      onTap: (index) {
        analytics.setCurrentScreen(
          screenName: '/home/${_tabs[index]}',
        );
        if (index == notifications) {
          final notif =
              RepositoryProvider.of<AppNotificationsUnreadStatusRepository>(
                  context);
          notif.setLatestNotificationReadTime();
        }
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
          icon: NotificationIndicator(
            child: Container(
              height: itemHeight,
              child: Icon(LineIcons.bell),
            ),
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
            title: 'Settings',
            showTitle: _currentIndex != profile,
          ),
        ),
        if (isAdmin == true)
          BottomNavigationBarItem(
            icon: Container(
              height: itemHeight,
              child: Icon(LineIcons.shield),
            ),
            title: BottomBarTitle(
              title: 'Admin',
              showTitle: _currentIndex != admin,
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

  _adminAwareIndex(int index, bool isAdmin) {
    return isAdmin == true ? index : (index == admin ? profile : index);
  }
}

class NotificationIndicator extends StatelessWidget {
  final Widget child;

  const NotificationIndicator({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final notif =
        RepositoryProvider.of<AppNotificationsUnreadStatusRepository>(context);
    return StreamBuilder<bool>(
      stream: notif.hasUnreadNotifications(),
      builder: (context, snapshot) {
        return Stack(
          children: <Widget>[
            child,
            if (snapshot.hasData && snapshot.data == true)
              Positioned(
                top: 10,
                right: 5,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
