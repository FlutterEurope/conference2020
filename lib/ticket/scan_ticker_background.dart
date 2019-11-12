import 'package:flutter/material.dart';

import 'scan_text_border_container.dart';

class ScanTicketBackground extends StatelessWidget {
  const ScanTicketBackground({
    Key key,
    this.topLimit,
    this.detectorHeight,
  }) : super(key: key);

  final double topLimit;
  final double detectorHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.black38,
            height: topLimit,
          ),
          Row(
            children: <Widget>[
              Container(
                color: Colors.black38,
                width: 35,
                height: detectorHeight,
              ),
              Expanded(
                child: ScanTextBorderContainer(),
              ),
              Container(
                color: Colors.black38,
                width: 35,
                height: detectorHeight,
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
