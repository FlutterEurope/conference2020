import 'package:conferenceapp/agenda/widgets/talk_card.dart';
import 'package:flutter/material.dart';

class ScanTicketCard extends StatelessWidget {
  const ScanTicketCard({
    Key key,
    this.title,
    this.value,
    this.hint,
  }) : super(key: key);

  final String title;
  final String value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 50.0,
      ),
      child: TalkCardDecoration(
        child: Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 16),
                if (value != null)
                  Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                if (value != null && hint != null) ...{
                  SizedBox(height: 10),
                  Text(
                    hint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                }
              ],
            ),
          ),
        ),
      ),
    );
  }
}
