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
  final topLimit = 200.0;
  final detectorHeight = 50.0;
  String orderId;
  String email;
  PageController controller;
  int currentPage = 0;
  bool correctData = false;

  @override
  void initState() {
    super.initState();
    controller = PageController(viewportFraction: 0.8)
      ..addListener(() {
        if (controller.page.round() != currentPage) {
          setState(() {
            currentPage = controller.page.round();
          });
        }
      });
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
                topLimit: topLimit,
                detectorHeight: detectorHeight,
                condition: (word) =>
                    detectionCondition(word, controller.page.round()),
                onDetected: (word) => onDetected(word, controller.page.round()),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: ScanTicketBackground(
                topLimit: topLimit,
                detectorHeight: detectorHeight,
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
                child: PageView(
                  controller: controller,
                  children: <Widget>[
                    ScanTicketCard(
                      title: 'Order ID',
                      value: orderId,
                      hint: 'Swipe right to scan your e-mail',
                    ),
                    ScanTicketCard(title: 'E-mail', value: email),
                  ],
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
                child:
                    SubmitScannedTicketButton(orderId: orderId, email: email),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool detectionCondition(String word, int page) {
    if (page == 0) {
      return word.startsWith('OT') && word.length == 9;
    } else {
      return word.contains('@') && word.length > 5;
    }
  }

  void onDetected(String result, int page) async {
    if (page == 0) {
      setState(() {
        orderId = result;
      });
    } else {
      setState(() {
        email = result;
      });
    }
    if (orderId != null &&
        detectionCondition(orderId, 0) &&
        email != null &&
        detectionCondition(email, 1)) {
      setState(() {
        correctData = true;
      });
    }
  }
}
