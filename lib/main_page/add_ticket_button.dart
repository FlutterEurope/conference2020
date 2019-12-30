import 'package:conferenceapp/ticket/bloc/bloc.dart';
import 'package:conferenceapp/ticket/ticket_page.dart';
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
        child: Center(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Theme.of(context).primaryColor,
            textTheme: ButtonTextTheme.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketPage(),
                  settings: RouteSettings(name: '/home/ticket_page'),
                ),
              );
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (state is NoTicketState) Text('Add your ticket'),
                  if (state is TicketAddedState) Text('Show your ticket'),
                  SizedBox(width: 12),
                  Icon(LineIcons.ticket),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
