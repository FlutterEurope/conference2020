import 'package:conferenceapp/common/appbar.dart';
import 'package:conferenceapp/ticket_check/bloc/ticket_check_bloc.dart';
import 'package:conferenceapp/ticket_check/bloc/ticket_check_event.dart';
import 'package:conferenceapp/ticket_check/bloc/ticket_check_state.dart';
import 'package:flutter/material.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:vibration/vibration.dart';

import 'scan_ticket_page.dart';

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
                    final bloc = TicketCheckBloc();
                    if (permission != PermissionStatus.granted) {
                      await requestCameraPermission();
                    }
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanTicketPage(
                          cameras: cameras,
                          bloc: bloc,
                        ),
                      ),
                    );
                    bloc.close();
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
