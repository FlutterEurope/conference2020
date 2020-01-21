import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ScanPartyPage extends StatelessWidget {
  final List<QrCameraDescription> cameras;

  const ScanPartyPage({Key key, this.cameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket scanning at the party'),
      ),
      body: ScanPartyPageContent(
        cameras: cameras,
      ),
    );
  }
}

class ScanPartyPageContent extends StatefulWidget {
  final List<QrCameraDescription> cameras;

  const ScanPartyPageContent({Key key, this.cameras}) : super(key: key);
  @override
  _ScanPartyPageContentState createState() => _ScanPartyPageContentState();
}

class _ScanPartyPageContentState extends State<ScanPartyPageContent> {
  QRReaderController controller;
  bool scanning = true;
  final collection = Firestore.instance.collection('party');

  @override
  void initState() {
    super.initState();
    onNewCameraSelected(widget.cameras[0]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Center(
            child: _cameraPreviewWidget(),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: collection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List array = snapshot.data.documents;
                final length = array.length;
                return Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black45,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        '$length',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
          if (!scanning)
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
      logger.errorException(e.description);
      showInSnackBar('Error: ${e.code}\n${e.description}');
    }

    if (mounted) {
      setState(() {});
      controller.startScanning();
    }
  }

  void onCodeRead(dynamic value) async {
    logger.info("Party ticket scanned, value detected: $value");
    Vibration.vibrate(duration: 300);

    try {
      final values = value.toString().split(' ');
      final id = values[0];
      final orderId =
          values[1].contains('OT') ? values[1].substring(2) : values[1];
      final ticketId = values[2];

      final doc = await collection.document('$id').get();
      if (doc?.exists == true) {
        showInSnackBar('Uczestnik już skanował bilet na imprezę');
      }

      final matchingTickets = await getMatchingTickets(orderId, ticketId);

      if (matchingTickets.length > 0) {
        final newDoc = await collection.document('$id').setData(
          {
            'updated': Timestamp.now(),
            'orderId': values[1],
            'ticketId': values[2],
          },
        );
        showInSnackBar('Ok, bilet prawidłowy ✓');
      } else {
        showInSnackBar('Nie ma takiego biletu ❗️❗️❗️❗️', Colors.red);
      }
    } catch (e, s) {
      logger.errorException(e, s);
    }
    startScanning();
  }

  void startScanning() async {
    logger.info("Starting scanning");
    try {
      await controller.stopScanning();
    } catch (e) {
      logger.errorException(e);
    }
    await Future.delayed(Duration(milliseconds: 1000));
    try {
      await controller.startScanning();
      setState(() {
        scanning = true;
      });
    } catch (e) {
      logger.errorException(e);
    }
  }

  void showInSnackBar(String message, [Color color = Colors.green]) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
    ));
  }

  Future<List> getMatchingTickets(String orderId, String ticketId) async {
    final ticketCollection = await getTicketsCollection();

    final checkByOrder = isCheckedByOrder(orderId);
    final matchigTickets = ticketCollection
        .where(checkByOrder
            ? (t) => t['orderId'] == orderId.toUpperCase()
            : (t) => t['ticketId'] == ticketId.toLowerCase())
        .toList();
    return matchigTickets;
  }

  bool isCheckedByOrder(String orderId) {
    return orderId.length > 1;
  }

  Future<List> getTicketsCollection() async {
    final tickets =
        await Firestore.instance.document('tickets/tickets').snapshots().first;

    final List ticketCollection = tickets.data['tickets'];
    return ticketCollection;
  }
}
