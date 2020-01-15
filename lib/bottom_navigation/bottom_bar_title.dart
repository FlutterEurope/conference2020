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
    final theme = Theme.of(context).textTheme;
    final factor = MediaQuery.of(context).textScaleFactor;
    return Container(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: showTitle
            ? Text(
                title,
                key: ValueKey(title),
              )
            : Container(
                height: 12 * factor * 1.35,
                key: ValueKey(title + "_idle"),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                    ),
                    height: 5,
                    width: 5,
                  ),
                ),
              ),
      ),
    );
  }
}
