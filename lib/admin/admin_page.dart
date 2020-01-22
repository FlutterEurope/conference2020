import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/common/europe_text_field.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/model/notification.dart';
import 'package:conferenceapp/notifications/repository/notifications_repository.dart';
import 'package:conferenceapp/profile/auth_repository.dart';
import 'package:conferenceapp/profile/settings_toggle.dart';
import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Load tickets from csv'),
              subtitle: Text(
                  'Select attendees.csv from Eventil to upload into Firestore. Will overwrite the existing database.'),
              trailing: Icon(LineIcons.file_text),
              onTap: () async {
                final res = await handleCsvTickets();
                if (res == false) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error during loading of the tickets.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            ListTile(
              title: Text('Add notification'),
              subtitle: Text(
                  'Notification will be visible on notifications page for all attendees.'),
              trailing: Icon(LineIcons.exclamation),
              onTap: () async => await handleAddingNotification(context),
            ),
            ListTile(
              title: Text('Create new ticketer'),
              subtitle: Text('This allows to create new ticketer'),
              trailing: Icon(LineIcons.smile_o),
              onTap: () async => await handleCreateNewUser(context),
            ),
            ListTile(
              title: Text('Logout'),
              trailing: Icon(LineIcons.sign_out),
              onTap: () async => await handleLogout(context),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Future handleAddingNotification(BuildContext context) async {
    final notification = await showDialog<AppNotification>(
      builder: (context) => NotificationDialog(),
      context: context,
    );
    if (notification != null) {
      final notifRepository =
          RepositoryProvider.of<FirestoreNotificationsRepository>(context);
      notifRepository.addNotification(notification);
      await Future.delayed(Duration(milliseconds: 500));
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            'Notification will be sent to the users and visible in Notifications panel'),
      ));
    }
  }

  Future handleCreateNewUser(BuildContext context) async {
    await showDialog(
      builder: (context) => SignupDialog(),
      context: context,
    );
  }

  Future handleLogout(BuildContext context) async {
    final auth = RepositoryProvider.of<AuthRepository>(context);
    await auth.signout();
  }

  Future<bool> handleCsvTickets() async {
    try {
      var file =
          await FilePicker.getFile(type: FileType.ANY, fileExtension: 'csv');

      if (file == null) return false;

      final yourString = await file.readAsString();
      var d = new FirstOccurrenceSettingsDetector(
        eols: ['\r\n', '\n'],
        textDelimiters: ['"', "'"],
      );

      final rowsAsListOfValues = const CsvToListConverter().convert(
        yourString,
        csvSettingsDetector: d,
      );

      final tickets = List<Map>();
      for (var att in rowsAsListOfValues.skip(1)) {
        final name = att[1];
        final name64 = base64.encode(utf8.encode(name));
        final email = att[2];
        final email64 = base64.encode(utf8.encode(email));
        final twitter = att[3];
        final ticketId = att[5].toString().toLowerCase();
        final orderId = att[15].toString().toUpperCase();
        final type = att[4];
        final ticket = {
          'name': name64,
          'email': email64,
          'ticketId': ticketId,
          'orderId': orderId,
          'type': type,
          'used': false
        };
        tickets.add(ticket);
      }

      final ticketDoc = Firestore.instance.document('/tickets/tickets');

      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot ticketsSnapshot = await tx.get(ticketDoc);
        if (!ticketsSnapshot.exists) {
          await tx.set(ticketDoc, {});
        }
        if (ticketsSnapshot.exists) {
          await tx.set(ticketDoc, <String, dynamic>{
            'tickets': tickets,
          });
        }
      });
      return true;
    } catch (e) {
      logger.errorException(e);
      return false;
    }
  }
}

class SignupDialog extends StatefulWidget {
  const SignupDialog({
    Key key,
  }) : super(key: key);

  @override
  _SignupDialogDialogState createState() => _SignupDialogDialogState();
}

class _SignupDialogDialogState extends State<SignupDialog> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add new ticketer'),
      contentPadding: EdgeInsets.all(12.0),
      children: <Widget>[
        EuropeTextFormField(
          hint: 'Email',
          value: email,
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).nextFocus();
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () async {
                try {
                  final doc =
                      Firestore.instance.collection('ticketers').document();
                  await doc.setData({'email': email});
                } catch (e) {
                  logger.errorException(e);
                }
                Navigator.pop(context);
              },
              child: Text('Register'),
              color: Colors.green,
            ),
            SizedBox(width: 16),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
              color: Colors.red,
            ),
          ],
        ),
      ],
    );
  }
}

class NotificationDialog extends StatefulWidget {
  const NotificationDialog({
    Key key,
  }) : super(key: key);

  @override
  _NotificationDialogState createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  String title;
  String content;
  DateTime dateTime = DateTime.now();
  bool important = false;
  String url;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add new notification'),
      contentPadding: EdgeInsets.all(12.0),
      children: <Widget>[
        EuropeTextFormField(
          hint: 'Title',
          value: title,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {
            setState(() {
              title = value;
            });
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).nextFocus();
          },
        ),
        EuropeTextFormField(
          hint: 'Content',
          value: content,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {
            setState(() {
              content = value;
            });
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).nextFocus();
          },
        ),
        EuropeTextFormField(
          hint: 'Url (not required)',
          value: url,
          keyboardType: TextInputType.url,
          textCapitalization: TextCapitalization.none,
          onChanged: (value) {
            setState(() {
              url = value;
            });
          },
          onFieldSubmitted: (_) {
            FocusScope.of(context).nextFocus();
          },
        ),
        SettingsToggle(
          title: 'Important',
          onChanged: (value) {
            setState(() {
              important = value;
            });
          },
          value: important,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop<AppNotification>(
                context,
                AppNotification(title, dateTime, content, important, url),
              ),
              child: Text('Save'),
              color: Colors.green,
            ),
            SizedBox(width: 16),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
              color: Colors.red,
            ),
          ],
        ),
      ],
    );
  }
}
