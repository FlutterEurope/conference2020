import 'package:flutter/material.dart';

import 'scan_text_border_container.dart';

class ScanTicketBackground extends StatelessWidget {
  const ScanTicketBackground({
    Key key,
    this.detectorHeight,
  }) : super(key: key);

  final double detectorHeight;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black38,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  color: Colors.black38,
                  height: detectorHeight,
                ),
              ),
              Container(
                width: width * 0.8,
                child: ScanTextBorderContainer(),
              ),
              Flexible(
                child: Container(
                  color: Colors.black38,
                  height: detectorHeight,
                ),
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
