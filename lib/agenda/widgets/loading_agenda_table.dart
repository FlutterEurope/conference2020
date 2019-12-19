import 'package:flutter/material.dart';

class LoadingAgendaTable extends StatelessWidget {
  const LoadingAgendaTable({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
