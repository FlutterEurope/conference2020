import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/ticket_check/bloc/bloc.dart';
import 'package:conferenceapp/ticket_check/users_list.dart';
import 'package:flutter/material.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';

import 'manual_ticket_check_page.dart';
import 'scan_party_page.dart';
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'Aby zeskanować bilet naciśnij "Skanuj bilety", a następnie skieruj aparat na kod QR na ekranie telefonu uczestnika.'),
            ),
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
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sprawdź ręcznie',
                  style: TextStyle(fontSize: 36),
                ),
              ),
              onPressed: () async {
                try {
                  final bloc = TicketCheckBloc();

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManualTicketPage(
                        bloc: bloc,
                      ),
                    ),
                  );
                  bloc.close();
                } catch (e, s) {
                  logger.errorException(e, s);
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Kontrola na imprezie',
                ),
              ),
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
                      builder: (context) => ScanPartyPage(
                        cameras: cameras,
                      ),
                    ),
                  );
                } on QRReaderException catch (e) {
                  logError(e.code, e.description);
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              child: Text('Przeglądaj sprawdzone'),
              onPressed: () async {
                try {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UsersListPage(),
                    ),
                  );
                } catch (e, s) {
                  logger.errorException(e, s);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
