import 'package:conferenceapp/ticket/add_ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class AddTicketButton extends StatelessWidget {
  const AddTicketButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Center(
        child: RaisedButton(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddTicketPage()));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Add your ticket'),
              SizedBox(width: 12),
              Icon(LineIcons.ticket),
            ],
          ),
        ),
      ),
    );
  }
}
