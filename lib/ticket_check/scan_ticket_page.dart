import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/ticket/widgets/ticket_clipper.dart';
import 'package:conferenceapp/ticket_check/bloc/bloc.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';

class ScanTicketPage extends StatefulWidget {
  final List<QrCameraDescription> cameras;
  final TicketCheckBloc bloc;

  const ScanTicketPage({Key key, this.cameras, this.bloc}) : super(key: key);
  @override
  _ScanTicketPageState createState() => _ScanTicketPageState();
}

class _ScanTicketPageState extends State<ScanTicketPage> {
  QRReaderController controller;
  bool scanning = true;

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
      body: BlocBuilder<TicketCheckBloc, TicketCheckState>(
          bloc: widget.bloc,
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                if (state is NoTicketCheckState)
                  Center(
                    child: _cameraPreviewWidget(),
                  ),
                ScanTopInfo(scanning: scanning),
                if (state is LoadingState)
                  Center(child: CircularProgressIndicator()),
                if (state is TicketScannedState)
                  TicketInfo(
                    bloc: widget.bloc,
                    state: state,
                  ),
                if (state is TicketValidatedState)
                  TicketValidated(
                    bloc: widget.bloc,
                    state: state,
                    onClose: startScanning,
                  ),
                if (state is TicketErrorState)
                  Center(child: Text('Error occured: ${state.reason}')),
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
            );
          }),
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
    logger.info("Stopping scanning, value detected: $value");
    Vibration.vibrate(duration: 300);
    setState(() {
      scanning = false;
    });
    try {
      controller.stopScanning();
    } catch (e, s) {
      logger.errorException(e, s);
    }

    if (value != null) {
      widget.bloc.add(TicketScanned(value));
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
      widget.bloc.add(InitEvent());
    } catch (e) {
      logger.errorException(e);
    }
  }

  void showInSnackBar(String message) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(message)));
  }
}

class TicketValidated extends StatelessWidget {
  const TicketValidated({
    Key key,
    this.bloc,
    this.state,
    this.onClose,
  }) : super(key: key);

  final TicketCheckBloc bloc;
  final TicketValidatedState state;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Ticket verified',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Container(
                height: 200,
                width: 200,
                child: Center(
                  child: FlareActor(
                    'assets/flare/success.flr',
                    animation: 'Untitled',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text('Order number: ${state.ticket?.orderId}'),
              Text('Ticket number: ${state.ticket?.ticketId}'),
              RaisedButton(
                child: Text('OK'),
                onPressed: () {
                  onClose();
                  // startScanning();
                  bloc.add(InitEvent());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TicketInfo extends StatelessWidget {
  const TicketInfo({
    Key key,
    @required this.bloc,
    @required this.state,
  }) : super(key: key);

  final TicketCheckBloc bloc;
  final TicketScannedState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipPath(
        clipper: TicketClipper(true, true),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Please confirm the data',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text('Order number: ${state.ticket?.orderId}'),
                Text('Ticket number: ${state.ticket?.ticketId}'),
                Text('Name: ${state.name}'),
                if (state.student)
                  Text(
                    'Student ticket - check student id',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Mark as present'),
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {
                        bloc.add(TickedValidated(
                          state.userId,
                          state.ticket,
                        ));
                      },
                    ),
                    SizedBox(width: 12),
                    RaisedButton(
                      child: Text('Cancel'),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        bloc.add(InitEvent());
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
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
