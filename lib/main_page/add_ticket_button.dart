import 'package:conferenceapp/ticket/bloc/bloc.dart';
import 'package:conferenceapp/ticket/ticket_page.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

class AddTicketButton extends StatelessWidget {
  const AddTicketButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketBloc, TicketState>(
      builder: (context, state) => Padding(
        padding: EdgeInsets.all(12.0),
        child: state is NoTicketState
            ? Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: FloatingActionButton.extended(
                  icon: DescribedFeatureOverlay(
                    featureId: 'show_ticket',
                    tapTarget: Icon(LineIcons.ticket),
                    title: Text('Add your ticket'),
                    description: Text(
                        'Tap this button to add your ticket. You\'ll need your order or ticket number.'),
                    backgroundColor: Theme.of(context).primaryColor,
                    onComplete: () async {
                      return true;
                    },
                    targetColor: Colors.white,
                    textColor: Colors.white,
                    child: Icon(LineIcons.ticket),
                  ),
                  shape: StadiumBorder(),
                  backgroundColor: Theme.of(context).primaryColor,
                  tooltip: 'Add your ticket',
                  isExtended: true,
                  label: Text(
                    'Add\nticket',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  onPressed: () => onPressed(context),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  backgroundColor: Theme.of(context).primaryColor,
                  tooltip: 'Show your ticket',
                  isExtended: true,
                  child: DescribedFeatureOverlay(
                    featureId: 'show_ticket',
                    tapTarget: Icon(LineIcons.ticket),
                    title: Text('Add your ticket'),
                    description: Text(
                        'Tap this button to see your ticket. You should show it during registration or swag pickup.'),
                    backgroundColor: Theme.of(context).primaryColor,
                    onComplete: () async {
                      return true;
                    },
                    targetColor: Colors.white,
                    textColor: Colors.white,
                    child: Icon(LineIcons.ticket),
                  ),
                  onPressed: () => onPressed(context),
                ),
              ),
      ),
    );
  }

  void onPressed(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketPage(),
        settings: RouteSettings(name: '/home/ticket_page'),
      ),
    );
  }
}
