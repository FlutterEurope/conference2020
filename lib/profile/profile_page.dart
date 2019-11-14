import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

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
          ],
        ),
      ),
    );
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
      Theme.of(context).brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    );
  }
}
