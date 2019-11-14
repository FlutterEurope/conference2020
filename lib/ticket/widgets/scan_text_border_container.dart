import 'package:flutter/material.dart';

class ScanTextBorderContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 20,
              width: 5,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 5,
              width: 20,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 20,
              width: 5,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 5,
              width: 20,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 20,
              width: 5,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 5,
              width: 20,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 20,
              width: 5,
              color: Colors.white,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 5,
              width: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
