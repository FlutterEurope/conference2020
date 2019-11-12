import 'package:conferenceapp/agenda/talk_card.dart';
import 'package:conferenceapp/common/appbar.dart';
import 'package:conferenceapp/common/europe_text_field.dart';
import 'package:conferenceapp/ticket/scan_ticket_page.dart';
import 'package:conferenceapp/ticket/ticket_data.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'add_ticket_email_info.dart';
import 'image_courtesy_text.dart';
import 'save_ticket_button.dart';
import 'scan_your_ticket_placeholder.dart';
import 'ticket_clipper.dart';
import 'ticket_page_title.dart';

class AddTicketPage extends StatefulWidget {
  @override
  _AddTicketPageState createState() => _AddTicketPageState();
}

class _AddTicketPageState extends State<AddTicketPage> {
  bool scanned = false;
  TicketData ticketData;
  TextEditingController orderController;
  TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    orderController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlutterEuropeAppBar(back: true),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipPath(
                    clipper: TicketClipper(),
                    child: TalkCardDecoration(
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              color: Theme.of(context).primaryColor,
                              height: 80,
                              child: TicketPageTitle(),
                            ),
                            GestureDetector(
                              onTap: onTap,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0,
                                ),
                                child: scanned
                                    ? QrImage(
                                        backgroundColor: Colors.white,
                                        data:
                                            "${ticketData?.orderId} ${ticketData?.email}",
                                        version: QrVersions.auto,
                                      )
                                    : ScanYourTicketPlaceholder(),
                              ),
                            ),
                            EuropeTextFormField(
                              hint: 'Type or scan order number',
                              icon: LineIcons.camera,
                              onTap: onTap,
                              controller: orderController,
                            ),
                            EuropeTextFormField(
                              hint: 'Type or scan your e-mail',
                              icon: LineIcons.camera,
                              onTap: onTap,
                              controller: emailController,
                            ),
                            if (scanned) SaveTicketButton(),
                            AddTicketEmailInfo(),
                            Container(
                              color: Theme.of(context).primaryColor,
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ImageLicenseText(),
            ],
          ),
        ),
      ),
    );
  }

  void onTap() async {
    final result = await Navigator.push<TicketData>(
      context,
      MaterialPageRoute(
        builder: (context) => ScanTicketPage(),
      ),
    );
    if (result != null) {
      ticketData = result;
      orderController.text = ticketData?.orderId;
      emailController.text = ticketData?.email?.toLowerCase();
    }

    setState(() {
      scanned = result?.filled == true;
    });
  }
}
