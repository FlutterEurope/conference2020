import 'package:flutter/material.dart';

class BottomBarTitle extends StatelessWidget {
  const BottomBarTitle({
    Key key,
    @required this.title,
    @required this.showTitle,
  }) : super(key: key);

  final String title;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: showTitle
          ? Text(
              title,
              key: ValueKey(title),
            )
          : Container(
              height: 12,
              width: 12,
              key: ValueKey(title + "_idle"),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  height: 5,
                  width: 5,
                ),
              ),
            ),
    );
  }
}
