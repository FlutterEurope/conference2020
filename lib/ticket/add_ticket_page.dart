import 'package:conferenceapp/common/appbar.dart';
import 'package:conferenceapp/ticket/ticket_detector.dart';
import 'package:flutter/material.dart';

class AddTicketPage extends StatefulWidget {
  @override
  _AddTicketPageState createState() => _AddTicketPageState();
}

class _AddTicketPageState extends State<AddTicketPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlutterEuropeAppBar(back: true),
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
          Flexible(child: TicketDetector(onDetected: (String orderNo) {
            print('Navigating to ticket page with $orderNo');
            Navigator.push(context, MaterialPageRoute(builder: (context) => TicketCompleteDataPage(orderNo)));
          })),
        ],
      ),
    );
  }
}

class TicketCompleteDataPage extends StatelessWidget {
  TicketCompleteDataPage(this.orderNo);

  final String orderNo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlutterEuropeAppBar(back: true),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Detected order number is:',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: orderNo,
                decoration: InputDecoration(
                  hintText: 'Order number',
                  labelText: 'Order number',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                keyboardAppearance: Theme.of(context).brightness,
                initialValue: orderNo,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Theme.of(context).brightness,
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  labelText: 'E-mail',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
