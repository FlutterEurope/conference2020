import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class SaveTicketButton extends StatelessWidget {
  const SaveTicketButton({
    Key key,
    this.enabled,
    this.onSave,
  }) : super(key: key);

  final bool enabled;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.green,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Save',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(width: 6),
          Icon(
            LineIcons.check_circle,
            color: Colors.white,
          )
        ],
      ),
      onPressed: enabled ? onSave : null,
    );
  }
}
