import 'package:conferenceapp/common/appbar.dart';
import 'package:conferenceapp/ticket/ticket_detector.dart';
import 'package:flutter/material.dart';

class AddTicketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlutterEuropeAppBar(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Target you camera to the e-mail with the ticket or Eventil webpage with your order.',
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'We are looking for order ID which is similar to',
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'OTYYYXXXX',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Flexible(child: TicketDetector()),
        ],
      ),
    );
  }
}
