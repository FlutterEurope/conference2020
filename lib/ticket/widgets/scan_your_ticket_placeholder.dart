import 'package:flutter/material.dart';

class ScanYourTicketPlaceholder extends StatelessWidget {
  const ScanYourTicketPlaceholder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Image.asset(
            'assets/scan_ticket.png',
            height: 220,
          ),
        ),
        Text(
          'Scan your ticket or type manually',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[700]
                : Colors.grey[200],
          ),
        )
      ],
    );
  }
}
