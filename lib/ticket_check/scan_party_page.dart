import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ScanPartyPage extends StatefulWidget {
  final List<QrCameraDescription> cameras;

  const ScanPartyPage({Key key, this.cameras}) : super(key: key);
  @override
  _ScanPartyPageState createState() => _ScanPartyPageState();
}

class _ScanPartyPageState extends State<ScanPartyPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket scanning at the party'),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
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
                      child: Text(
                        '$length',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            Center(
              child: _cameraPreviewWidget(),
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

  void onCodeRead(dynamic value) {
    logger.info("Stopping scanning, value detected: $value");
    Vibration.vibrate(duration: 300);

    // setState(() {
    //   scanning = false;
    // });
    try {
      final values = value.toString().split(' ');
      final id = values[0];
      collection.document('$id').setData(
        {
          'updated': Timestamp.now(),
          'orderId': values[1],
          'ticketId': values[2],
        },
      );
      // controller.stopScanning();
    } catch (e, s) {
      logger.errorException(e, s);
    }
  }

  void startScanning() {
    logger.info("Starting scanning");
    try {
      if (scanning == false) controller.stopScanning();
    } catch (e) {
      logger.errorException(e);
    }
    try {
      controller.startScanning();
      setState(() {
        scanning = true;
      });
    } catch (e) {
      logger.errorException(e);
    }
  }

  void showInSnackBar(String message) {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(message),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
