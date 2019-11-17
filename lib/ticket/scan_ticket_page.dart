import 'package:conferenceapp/common/appbar.dart';
import 'package:flutter/material.dart';

import 'widgets/scan_ticker_background.dart';
import 'widgets/scan_ticket_card.dart';
import 'widgets/submit_scanned_ticket_button.dart';
import 'image_detection/ticket_detector.dart';

class ScanTicketPage extends StatefulWidget {
  @override
  _ScanTicketPageState createState() => _ScanTicketPageState();
}

class _ScanTicketPageState extends State<ScanTicketPage> {
  final detectorHeight = 50.0;
  String orderId;
  bool correctData = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: FlutterEuropeAppBar(back: true),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: TicketDetector(
                detectorHeight: detectorHeight,
                condition: detectionCondition,
                onDetected: onDetected,
                overlay: ScanTicketBackground(
                  detectorHeight: detectorHeight,
                ),
              ),
            ),
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Text(
                'Point your camera to order number and your e-mail',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Container(
                height: 300,
                child: ScanTicketCard(
                  title: 'Order ID',
                  value: orderId,
                  hint: 'Swipe right to scan your e-mail',
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: correctData ? 1 : 0,
                duration: Duration(milliseconds: 500),
                child: SubmitScannedTicketButton(orderId: orderId),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool detectionCondition(String word) {
    return word.startsWith('OT') && word.length == 9;
  }

  void onDetected(String result) async {
    setState(() {
      orderId = result;
    });

    if (orderId != null && detectionCondition(orderId)) {
      setState(() {
        correctData = true;
      });
    }
  }
}
