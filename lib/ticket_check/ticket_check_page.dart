import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/common/appbar.dart';
import 'package:flutter/material.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:line_icons/line_icons.dart';
import 'package:vibration/vibration.dart';

class TicketCheckPage extends StatefulWidget {
  @override
  _TicketCheckPageState createState() => _TicketCheckPageState();
}

class _TicketCheckPageState extends State<TicketCheckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlutterEuropeAppBar(
        back: true,
        search: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('Scan ticket'),
                onPressed: () async {
                  try {
                    final cameras = await availableCameras();
                    final permission = await checkCameraPermission();
                    if (permission != PermissionStatus.granted) {
                      await requestCameraPermission();
                    }
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanTicketPage(
                          cameras: cameras,
                        ),
                      ),
                    );
                  } on QRReaderException catch (e) {
                    logError(e.code, e.description);
                  }
                },
              ),
              RaisedButton(
                child: Text('Add manually'),
                onPressed: null,
              ),
              RaisedButton(
                child: Text('Browse scanned tickets'),
                onPressed: null,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ScanTicketPage extends StatefulWidget {
  final List<QrCameraDescription> cameras;

  const ScanTicketPage({Key key, this.cameras}) : super(key: key);
  @override
  _ScanTicketPageState createState() => _ScanTicketPageState();
}

class _ScanTicketPageState extends State<ScanTicketPage> {
  QRReaderController controller;
  bool scanning = true;
  _MatchingTicket currentTicket;

  @override
  void initState() {
    super.initState();
    onNewCameraSelected(widget.cameras[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket scanning'),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: _cameraPreviewWidget(),
          ),
          ScanTopInfo(scanning: scanning),
          if (currentTicket != null)
            Center(
              //TODO: get ticket data from firestore
              //TODO: if more than one tickets on one order let know that m/n will be used
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(LineIcons.close),
                        onPressed: () {
                          setState(() {
                            currentTicket = null;
                          });
                        },
                      ),
                      Text(
                        'Please confirm the data',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Scanned ticket:'),
                      Text('Order number: ${currentTicket?.orderId}'),
                      Text('Ticket number: ${currentTicket?.ticketId}'),
                      Text('Name: ${currentTicket?.name}'),
                      // Text('Student ticket - check student id'),
                      RaisedButton(
                        child: Text('Mark as present'),
                        onPressed: () {
                          //TODO: add ticket info to the user profile
                          //TODO: mark ticket as used
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: startScanning,
                child: Text('Scan again'),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'No camera selected',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return new AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: new QRReaderPreview(controller),
      );
    }
  }

  void onNewCameraSelected(QrCameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = new QRReaderController(
      cameraDescription,
      ResolutionPreset.low,
      [
        CodeFormat.qr,
        CodeFormat.pdf417,
      ],
      onCodeRead,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on QRReaderException catch (e) {
      logError(e.code, e.description);
      showInSnackBar('Error: ${e.code}\n${e.description}');
    }

    if (mounted) {
      setState(() {});
      controller.startScanning();
    }
  }

  void onCodeRead(dynamic value) {
    Vibration.vibrate(duration: 300);
    print(value);
    controller.stopScanning();
    setState(() {
      scanning = false;
    });
    if (value != null) {
      handleResult(value.toString());
    }
  }

  void handleResult(String value) async {
    String orderId;
    String ticketId;
    bool checkByOrder;
    if (value.length > 7) {
      orderId = '';
      ticketId = value;
      checkByOrder = false;
    } else {
      orderId = value;
      ticketId = '';
      checkByOrder = true;
    }
    final tickets =
        await Firestore.instance.document('tickets/tickets').snapshots().first;
    final List ticketCollection = tickets.data['tickets'];
    if (ticketCollection != null && ticketCollection.length > 0) {
      final matchigTickets = ticketCollection
          .where(checkByOrder
              ? (t) => t['orderId'] == orderId
              : (t) => t['ticketId'] == ticketId)
          .toList();
      if (matchigTickets.length == 1) {
        final selectedTicket = matchigTickets[0];
        print(selectedTicket);
        final matchingOrderId = selectedTicket['orderId'];
        final matchingTicketId = selectedTicket['ticketId'];
        final matchingEmail = selectedTicket['email'];
        final matchingName = selectedTicket['name'];
        final matchingTicket = _MatchingTicket(
            matchingOrderId, matchingTicketId, matchingEmail, matchingName);
        setState(() {
          currentTicket = matchingTicket;
        });
      } else if (matchigTickets.length > 1) {
        //todo
        print(matchigTickets);
      }
    }
  }

  void startScanning() {
    try {
      controller.stopScanning();
      controller.startScanning();
      setState(() {
        scanning = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void showInSnackBar(String message) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(message)));
  }
}

class _MatchingTicket {
  final String email;
  final String orderId;
  final String ticketId;
  final String name;

  _MatchingTicket(this.orderId, this.ticketId, String email, String name)
      : email = utf8.decode(base64Decode(email)),
        name = utf8.decode(base64Decode(name));
}

class ScanTopInfo extends StatelessWidget {
  const ScanTopInfo({
    Key key,
    this.scanning = false,
  }) : super(key: key);

  final bool scanning;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white70,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!scanning) Text('Press Scan button'),
              if (scanning) Text('Scanning QR Code'),
              if (scanning)
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(strokeWidth: 1)),
                ),
            ],
          )),
        ),
      ),
    );
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');
