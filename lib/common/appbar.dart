import 'package:conferenceapp/agenda/helpers/agenda_layout_helper.dart';
import 'package:feature_discovery/feature_discovery.dart';
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
                'assets/flutter_europe.png',
                height: imageHeight,
                key: ValueKey('logo_image_1'),
              )
            : Image.asset(
                'assets/flutter_europe_dark.png',
                height: imageHeight,
                key: ValueKey('logo_image_2'),
              ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      brightness: Theme.of(context).brightness,
      iconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: Theme.of(context).accentColor),
      leading: back
          ? null
          : Semantics(
              button: true,
              enabled: true,
              focusable: true,
              child: Tooltip(
                message: 'Search for a talk or speaker',
                child: Container(
                  child: IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(Icons.search),
                    onPressed: onSearch,
                  ),
                ),
              ),
            ),
      actions: <Widget>[
        layoutSelector ? ToggleLayoutButton() : Container(),
      ],
    );
  }

  @override
  final Size preferredSize;
}

class ToggleLayoutButton extends StatelessWidget {
  const ToggleLayoutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icon = Semantics(
      button: true,
      enabled: true,
      focusable: true,
      hint: 'Change the layout of the agenda',
      child: Tooltip(
        message: 'Change the layout of the agenda',
        child: IconButton(
          color: Theme.of(context).accentColor,
          icon: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: Provider.of<AgendaLayoutHelper>(context, listen: false)
                      .isCompact()
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
            await Provider.of<AgendaLayoutHelper>(context, listen: false)
                .toggleCompact();
          },
        ),
      ),
    );

    return DescribedFeatureOverlay(
      featureId: 'show_how_to_toggle_layout',
      tapTarget: icon,
      title: Text('Toggle agenda layout'),
      description: Text(
          'Tap this icon to change layout to full width. Tap anywhere else to dismiss this info.'),
      backgroundColor: Theme.of(context).primaryColor,
      onComplete: () async {
        return true;
      },
      targetColor: Colors.white,
      textColor: Colors.white,
      child: icon,
    );
  }
}
