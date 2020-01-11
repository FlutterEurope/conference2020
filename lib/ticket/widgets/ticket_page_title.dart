import 'package:flutter/material.dart';

class TicketPageTitle extends StatelessWidget {
  const TicketPageTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Your ticket',
        style: TextStyle(
          fontSize: 22,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.grey[200],
        ),
      ),
    );
  }
}
