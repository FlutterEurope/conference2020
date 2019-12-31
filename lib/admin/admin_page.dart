import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/common/europe_text_field.dart';
import 'package:conferenceapp/model/notification.dart';
import 'package:conferenceapp/notifications/repository/notifications_repository.dart';
import 'package:conferenceapp/profile/profile_page.dart';
import 'package:conferenceapp/profile/settings_toggle.dart';
import 'package:conferenceapp/ticket_check/ticket_check_page.dart';
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
              title: Text('Start tickets check'),
              subtitle: Text(
                  'Point camera at the QR code visible on attendee\'s smartphone screen.'),
              trailing: Icon(LineIcons.ticket),
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TicketCheckPage(),
                    settings: RouteSettings(name: 'admin/ticket_check'),
                  ),
                );
              },
            ),
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
            Spacer(),
            VersionInfo(),
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
    }
  }

  Future<bool> handleCsvTickets() async {
    try {
      var file =
          await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'csv');
      print(file);

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
        final ticketId = att[5];
        final orderId = att[15];
        final ticket = {
          'name': name64,
          'email': email64,
          'ticketId': ticketId,
          'orderId': orderId,
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
          await tx.update(ticketDoc, <String, dynamic>{
            'tickets': tickets,
          });
        }
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
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

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Add new notification'),
      contentPadding: EdgeInsets.all(12.0),
      children: <Widget>[
        EuropeTextFormField(
          hint: 'Title',
          value: title,
          onChanged: (value) {
            setState(() {
              title = value;
            });
          },
        ),
        EuropeTextFormField(
          hint: 'Content',
          value: content,
          onChanged: (value) {
            setState(() {
              content = value;
            });
          },
        ),
        FlatButton(
          child: Text('Date: $dateTime'),
          onPressed: () async {
            await showDatePicker(
              context: context,
              firstDate: DateTime.now().subtract(Duration(days: 1)),
              lastDate: DateTime.now().add(Duration(days: 2)),
              initialDate: DateTime.now(),
            );
            await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
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
                AppNotification(title, dateTime, content, important),
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
