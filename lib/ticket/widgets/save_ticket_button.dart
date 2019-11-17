import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class SaveTicketButton extends StatelessWidget {
  const SaveTicketButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.green,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Save'),
          SizedBox(width: 6),
          Icon(LineIcons.check_circle)
        ],
      ),
      onPressed: () {},
    );
  }
}
