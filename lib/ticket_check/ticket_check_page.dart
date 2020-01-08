import 'package:conferenceapp/ticket_check/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';

import 'scan_ticket_page.dart';

class TicketCheckPage extends StatefulWidget {
  @override
  _TicketCheckPageState createState() => _TicketCheckPageState();
}

class _TicketCheckPageState extends State<TicketCheckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Skanuj bilety',
                  style: TextStyle(fontSize: 36),
                ),
              ),
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
              child: Text('Przeglądaj uczestników'),
              onPressed: null,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Aby zeskanować bilet naciśnij "Skanuj bilety", a następnie skieruj aparat na kod QR na ekranie telefonu uczestnika.'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'W przypadku biletów studenckich sprawdź legitymację studencką lub inny dokument upoważniający do zniżki.'),
            ),
          ],
        ),
      ),
    );
  }
}
