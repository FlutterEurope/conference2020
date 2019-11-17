import 'package:conferenceapp/ticket/ticket_data.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class SubmitScannedTicketButton extends StatelessWidget {
  const SubmitScannedTicketButton({
    Key key,
    @required this.orderId,
  }) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: RaisedButton(
          color: Colors.green,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Submit'),
              SizedBox(width: 6),
              Icon(LineIcons.check_circle)
            ],
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.maybePop(context, TicketData(orderId, null));
            }
          },
        ),
      ),
    );
  }
}
