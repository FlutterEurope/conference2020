import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conferenceapp/common/logger.dart';
import 'package:conferenceapp/profile/auth_repository.dart';
import 'package:conferenceapp/ticket_check/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'W przypadku biletów studenckich sprawdź legitymację studencką lub inny dokument upoważniający do zniżki.'),
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
            RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Sprawdź ręcznie',
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
            RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Wydawanie koszulek',
                ),
              ),
            ),
            RaisedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Kontrola na imprezie',
                ),
              ),
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

class UsersListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tickets =
        Firestore.instance.collection('tickets_checked').snapshots();
    final authRepo = RepositoryProvider.of<AuthRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista sprawdzonych biletów'),
      ),
      body: StreamBuilder<bool>(
          stream: authRepo.isAdmin,
          builder: (context, isAdmin) {
            return StreamBuilder<QuerySnapshot>(
              stream: tickets,
              builder: (context, list) {
                if (list.hasData)
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('W sumie sprawdzono: ${list.data.documents.length}'),
                      ),
                      Flexible(child: TicketsList(list, isAdmin)),
                    ],
                  );
                else
                  return CircularProgressIndicator();
              },
            );
          }),
    );
  }

  String formatTimestamp(int timestamp) {
    var format = new DateFormat('d MMM, hh:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return format.format(date);
  }
}

class TicketsList extends StatelessWidget {
  const TicketsList(
    this.list,
    this.isAdmin, {
    Key key,
  }) : super(key: key);

  final AsyncSnapshot<QuerySnapshot> list;
  final AsyncSnapshot<bool> isAdmin;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.data.documents.length,
      itemBuilder: (ctx, indx) {
        final doc = list.data.documents[indx].data;
        final DateTime date = doc['updated'].toDate();
        return ListTile(
          title: SelectableText('${doc["orderId"]} / ${doc['ticketId']}'),
          subtitle: Text('$date'),
          trailing: isAdmin.hasData && isAdmin.data == true
              ? IconButton(
                  icon: Icon(LineIcons.trash),
                  onPressed: () async => await Firestore.instance
                      .collection('tickets_checked')
                      .document(doc['ticketId'])
                      .delete(),
                )
              : null,
        );
      },
    );
  }
}
