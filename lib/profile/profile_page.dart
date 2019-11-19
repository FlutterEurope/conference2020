import 'package:conferenceapp/analytics.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'authenticator_button.dart';
import 'settings_toggle.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
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
              onChanged: (_) {},
              value: true,
            ),
            SettingsToggle(
              title: 'Push Notifications from organizers',
              onChanged: (_) {},
              value: true,
            ),
            AuthenticatorButton(),
            FlatButton(
              child: Text('Send test crash 🤯'),
              onPressed: () {
                try {
                  throw Exception();
                } catch (e, s) {
                  Crashlytics.instance.recordError(e, s);
                }
              },
            ),
            VersionInfo()
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
            return Text('Version: ${pkg.version} (${pkg.buildNumber})');
          }
          return Container();
        },
      ),
    );
  }
}
