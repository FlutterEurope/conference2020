import 'package:flutter/material.dart';

import 'account_avatar.dart';

class FlutterEuropeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  FlutterEuropeAppBar({
    Key key,
    this.back = false,
    this.search = true,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final bool back;
  final bool search;

  @override
  Widget build(BuildContext context) {
    final imageHeight = 48.0;
    return AppBar(
      centerTitle: true,
      title: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: Theme.of(context).brightness == Brightness.light
            ? Image.asset(
                'assets/logo_negative.png',
                height: imageHeight,
                key: ValueKey('logo_image_1'),
              )
            : Image.asset(
                'assets/logo_negative_dark.png',
                height: imageHeight,
                key: ValueKey('logo_image_2'),
              ),
      ),
      elevation: 0,
      leading: back ? null : AccountAvatar(),
      actions: <Widget>[
        search
            ? IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )
            : Container(),
      ],
    );
  }

  @override
  final Size preferredSize;
}
