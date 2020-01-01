import 'package:conferenceapp/analytics.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authenticator_button.dart';
import 'settings_toggle.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int counter = 0;
  bool authVisible = false;

  @override
  Widget build(BuildContext context) {
    final sharedPrefs = Provider.of<SharedPreferences>(context);
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            SettingsToggle(
              title: 'Dark Theme',
              onChanged: (_) => changeBrightness(),
              value: Theme.of(context).brightness == Brightness.dark,
            ),
            SettingsToggle(
              title: 'Reminders',
              onChanged: (value) {
                sharedPrefs.setBool('reminders', value);
                setState(() {});
              },
              value: sharedPrefs.getBool('reminders') == true,
            ),
            ListTile(
              title: Text('Sponsors'),
              subtitle: Text('See who supported us'),
              trailing: Icon(LineIcons.angle_right),
              onTap: () {},
            ),
            ListTile(
              title: Text('Organizers'),
              subtitle: Text('See who created this event'),
              trailing: Icon(LineIcons.angle_right),
              onTap: () {},
            ),
            ListTile(
              title: Text('Send feedback'),
              subtitle: Text(
                  'Let us know if you find any errors or want to share your feedback with us'),
              trailing: Icon(LineIcons.angle_right),
              onTap: () {},
            ),
            ListTile(
              title: Text('Open source licenses'),
              trailing: Icon(LineIcons.angle_right),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
            Spacer(),
            Visibility(
              visible: authVisible,
              child: AuthenticatorButton(),
            ),
            GestureDetector(
              onTap: () {
                counter++;
                if (counter > 8) {
                  setState(() {
                    authVisible = true;
                  });
                }
              },
              child: VersionInfo(),
            )
          ],
        ),
      ),
    );
  }

  void changeBrightness() {
    final target = Theme.of(context).brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
    final paramValue = target == Brightness.light ? 'light' : 'dark';
    analytics.logEvent(
      name: 'settings_theme',
      parameters: {'target': paramValue},
    );
    analytics.setUserProperty(name: 'theme', value: paramValue);
    DynamicTheme.of(context).setBrightness(target);
  }
}

class VersionInfo extends StatelessWidget {
  const VersionInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pkg = snapshot.data;
            return Row(
              children: <Widget>[
                Text('V. ${pkg.version} (${pkg.buildNumber})'),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
