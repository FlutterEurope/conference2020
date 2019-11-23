import 'package:conferenceapp/agenda/helpers/agenda_layout_helper.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class FlutterEuropeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  FlutterEuropeAppBar({
    Key key,
    this.back = false,
    this.search = true,
    this.layoutSelector = false,
    this.onSearch,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final bool back;
  final bool search;
  final bool layoutSelector;
  final VoidCallback onSearch;

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
      leading: back
          ? null
          : Semantics(
              button: true,
              enabled: true,
              focusable: true,
              child: Tooltip(
                message: 'Search for a talk or speaker',
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: onSearch,
                ),
              ),
            ),
      actions: <Widget>[
        layoutSelector
            ? Semantics(
                button: true,
                enabled: true,
                focusable: true,
                hint: 'Change the layout of the agenda',
                child: Tooltip(
                  message: 'Change the layout of the agenda',
                  child: IconButton(
                    icon: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        child:
                            Provider.of<AgendaLayoutHelper>(context).isCompact()
                                ? Icon(
                                    LineIcons.database,
                                    size: 24,
                                    key: ValueKey('icon0'),
                                  )
                                : Icon(
                                    LineIcons.columns,
                                    size: 22,
                                    key: ValueKey('icon1'),
                                  )),
                    onPressed: () async {
                      await Provider.of<AgendaLayoutHelper>(context)
                          .toggleCompact();
                    },
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  final Size preferredSize;
}
