import 'package:conferenceapp/agenda/talk_card.dart';
import 'package:conferenceapp/common/appbar.dart';
import 'package:conferenceapp/common/europe_text_field.dart';
import 'package:conferenceapp/ticket/bloc/bloc.dart';
import 'package:conferenceapp/ticket/scan_ticket_page.dart';
import 'package:conferenceapp/ticket/ticket_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import 'widgets/add_ticket_email_info.dart';
import 'widgets/image_courtesy_text.dart';
import 'widgets/qr_image.dart';
import 'widgets/save_ticket_button.dart';
import 'widgets/scan_your_ticket_placeholder.dart';
import 'widgets/ticket_clipper.dart';
import 'widgets/ticket_page_title.dart';

class TicketPage extends StatefulWidget {
  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
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
    return BlocBuilder<TicketBloc, TicketState>(
      builder: (context, state) => Scaffold(
        appBar: FlutterEuropeAppBar(back: true, search: false),
        body: TicketPageWrapper(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              height: 80,
              child: TicketPageTitle(),
            ),
            if (state is TicketValidState)
              QrCode(ticketData: ticketData)
            else
              NoQrCode(onTap: onTap),
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
            if (state is TicketErrorState) Text('We have some problems 😅'),
            if (state is TicketDataFilledState) SaveTicketButton(),
            AddTicketEmailInfo(),
            Container(
              color: Theme.of(context).primaryColor,
              height: 50,
            ),
          ],
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
      // scanned = result?.filled == true;
    });
  }
}

class NoQrCode extends StatelessWidget {
  const NoQrCode({
    Key key,
    this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40.0,
        ),
        child: ScanYourTicketPlaceholder(),
      ),
    );
  }
}

class QrCode extends StatelessWidget {
  const QrCode({
    Key key,
    @required this.ticketData,
  }) : super(key: key);

  final TicketData ticketData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      child: QrImage(
        backgroundColor: Colors.white,
        data: "${ticketData?.orderId} ${ticketData?.email}",
      ),
    );
  }
}

class TicketPageWrapper extends StatelessWidget {
  const TicketPageWrapper({Key key, this.children}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                        children: children,
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
    );
  }
}
