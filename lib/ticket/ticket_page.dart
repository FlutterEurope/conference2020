import 'package:conferenceapp/agenda/widgets/talk_card.dart';
import 'package:conferenceapp/common/europe_text_field.dart';
import 'package:conferenceapp/ticket/bloc/bloc.dart';
import 'package:conferenceapp/ticket/ticket_data.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import 'widgets/add_ticket_email_info.dart';
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
  TextEditingController ticketController;
  TextEditingController personalEmailController;
  FocusNode orderNode;
  FocusNode emailNode;
  FocusNode ticketNode;
  FocusNode personalEmailNode;

  bool verifyByOrderNumber = false;
  bool verifyByTicketNumber = false;
  bool formValid = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    orderController = TextEditingController();
    orderNode = FocusNode();
    emailController = TextEditingController();
    emailNode = FocusNode();
    ticketController = TextEditingController();
    ticketNode = FocusNode();
    personalEmailController = TextEditingController();
    personalEmailNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketBloc, TicketState>(
      builder: (context, state) => Scaffold(
        body: Form(
          key: _formKey,
          child: TicketPageWrapper(
            children: <Widget>[
              if (state is TicketValidState)
                QrCode(ticketData: ticketData)
              else
                NoQrCode(onTap: () {}),
              if (!(state is TicketValidState))
                ToggleButtons(
                  isSelected: [verifyByOrderNumber, verifyByTicketNumber],
                  onPressed: (index) {
                    setState(() {
                      if (index == 0) {
                        verifyByOrderNumber = true;
                        verifyByTicketNumber = false;
                      } else {
                        verifyByOrderNumber = false;
                        verifyByTicketNumber = true;
                      }
                    });
                  },
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Order number'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Ticket number'),
                    )
                  ],
                ),
              if (verifyByOrderNumber && !(state is TicketValidState))
                EuropeTextFormField(
                  hint: 'Order number (#XXXXXXX)',
                  // icon: LineIcons.camera,
                  // onTap: onTap,
                  onFieldSubmitted: onSubmit,
                  controller: orderController,
                  focusNode: orderNode,
                  textCapitalization: TextCapitalization.characters,
                ),
              if (verifyByTicketNumber && !(state is TicketValidState))
                EuropeTextFormField(
                  hint: 'Ticket number (xXxXxXxXxXxXxX)',
                  // icon: LineIcons.camera,
                  // onTap: onTap,
                  onFieldSubmitted: onSubmit,
                  controller: ticketController,
                  focusNode: ticketNode,
                  textCapitalization: TextCapitalization.characters,
                ),
              // EuropeTextFormField(
              //   hint: 'E-mail connected with order',
              //   onFieldSubmitted: nextNode,
              //   controller: emailController,
              //   focusNode: emailNode,
              //   keyboardType: TextInputType.emailAddress,
              // ),
              // EuropeTextFormField(
              //   hint: 'Your e-mail (not needed if different than order e-mail)',
              //   onFieldSubmitted: nextNode,
              //   controller: personalEmailController,
              //   focusNode: personalEmailNode,
              //   keyboardType: TextInputType.emailAddress,
              // ),
              if (state is TicketErrorState)
                Text('We have some problems 😅'),
              if (!(state is TicketValidState))
                SaveTicketButton(
                  enabled: formValid,
                  onSave: onSave,
                ),
              if (!(state is TicketValidState))
                AddTicketEmailInfo(),

              if (state is TicketValidState)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Order number: ${ticketData.orderId}',
                    textAlign: TextAlign.center,
                  ),
                ),
              if (state is TicketValidState)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Ticket number: ${ticketData.ticketId}',
                    textAlign: TextAlign.center,
                  ),
                ),
              if (state is TicketValidState)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Show this QR code during registration at the event',
                    textAlign: TextAlign.center,
                  ),
                ),
              if (state is TicketValidState)
                ConferenceInfo(),
              Container(
                color: Theme.of(context).primaryColor,
                height: 50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Tooltip(
                      message: 'Yes, that\'s ToggleButton over there 😉',
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          LineIcons.question_circle,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    emailNode.dispose();
    orderController.dispose();
    orderNode.dispose();
    personalEmailController.dispose();
    personalEmailNode.dispose();
    ticketController.dispose();
    ticketNode.dispose();
    super.dispose();
  }

  // void onTap() async {
  //   final result = await Navigator.push<TicketData>(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ScanTicketPage(),
  //       settings: RouteSettings(name: '/home/ticket_page/scan_ticket_page'),
  //     ),
  //   );
  //   // extract this to react on controller changes as well as scanning
  //   if (result != null) {
  //     ticketData = result;
  //     orderController.text = ticketData?.orderId;
  //     emailController.text = ticketData?.email?.toLowerCase();

  //     BlocProvider.of<TicketBloc>(context).add(FillTicketData(ticketData));
  //   }
  // }

  void onOrderSubmitted(String value) {
    FocusScope.of(context).requestFocus(emailNode);
  }

  void onSave() {
    ticketData =
        TicketData(orderController.value.text, ticketController.value.text);
    if (verifyByOrderNumber) {
      BlocProvider.of<TicketBloc>(context).add(SaveTicket(ticketData));
    } else if (verifyByTicketNumber) {
      BlocProvider.of<TicketBloc>(context).add(SaveTicket(ticketData));
    }
  }

  void onSubmit(String value) {
    FocusScope.of(context).requestFocus(FocusNode());
    final valid = _formKey.currentState.validate();
    print(valid);
    setState(() {
      formValid = valid;
    });
  }
}

class ConferenceInfo extends StatelessWidget {
  const ConferenceInfo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: DottedBorder(
        borderType: BorderType.Rect,
        dashPattern: [4, 4],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Venue:',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Conference Centre',
                      textAlign: TextAlign.left,
                      softWrap: true,
                      maxLines: 2,
                    ),
                    Text(
                      'Copernicus Science Centre',
                      textAlign: TextAlign.left,
                      softWrap: true,
                      maxLines: 2,
                    ),
                    Text(
                      'Wybrzeże Kościuszkowskie 20',
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      '00-390 Warsaw',
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(LineIcons.map_signs),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
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
      width: 260,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: QrImage(
          //todo
          data: ticketData?.ticketId ?? ticketData?.orderId,
        ),
      ),
    );
  }
}

class TicketPageWrapper extends StatelessWidget {
  const TicketPageWrapper({Key key, this.children}) : super(key: key);
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final imageHeight = 48.0;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: imageHeight,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              iconTheme: Theme.of(context).iconTheme,
              title: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Theme.of(context).brightness == Brightness.light
                    ? Image.asset(
                        'assets/flutter_europe.png',
                        height: imageHeight,
                        key: ValueKey('logo_image_1'),
                      )
                    : Image.asset(
                        'assets/flutter_europe_dark.png',
                        height: imageHeight,
                        key: ValueKey('logo_image_2'),
                      ),
              ),
              pinned: true,
              bottom: PreferredSize(
                preferredSize: Size(20, 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ClipPath(
                    clipper: TicketClipper(true, false),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      height: 80,
                      child: TicketPageTitle(),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ClipPath(
                  clipper: TicketClipper(false, true),
                  child: TalkCardDecoration(
                    child: Container(
                      child: Column(
                        children: children,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
