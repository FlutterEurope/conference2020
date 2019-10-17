import 'package:flutter/material.dart';

class AgendaPage extends StatelessWidget {
  const AgendaPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Flutter Europe app demo'),
        ],
      ),
    );
  }
}
