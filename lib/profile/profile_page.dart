import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/agenda/repository/mock_talks_repository.dart';
import 'package:conferenceapp/model/talk_list.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              value: false,
            ),
            SettingsToggle(
              title: 'Push Notifications from organizers',
              onChanged: (_) {},
              value: false,
            ),
            FlatButton(
              child: Text('Authenticate'),
              onPressed: () async {
                await showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text('Login to continue'),
                        children: <Widget>[
                          FlatButton(
                            child: Text('Login'),
                            onPressed: () async {
                              final FirebaseAuth _auth = FirebaseAuth.instance;
                              try {
                                final result = await _auth.signInWithEmailAndPassword(
                                  //TODO place credentials here
                                  email: '',
                                  password: '',
                                );
                                print(result);
                              } catch (e) {
                                print(e);
                              }
                            },
                          )
                        ],
                      );
                    });
              },
            ),
            FlatButton(
              child: Text('Update mock data in Firestore'),
              onPressed: () {
                try {
                  // final data =
                  //     // MockTalksRepository().talks.where((d) => d.dateTime.isAfter(DateTime(2020, 1, 24))).toList();
                  // final list = TalkList(DateTime(2020, 1, 23), data);
                  // Firestore.instance.collection('talks').document().setData(list.toJson());
                } catch (e) {
                  print(e);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
      Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    );
  }
}
