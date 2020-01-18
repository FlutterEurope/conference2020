import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class LearnFeaturesButton extends StatelessWidget {
  const LearnFeaturesButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: IconButton(
        color: Theme.of(context).primaryColor,
        onPressed: () {
          FeatureDiscovery.discoverFeatures(
            context,
            const <String>{
              'show_ticket',
              'show_how_to_toggle_layout',
            },
          );
        },
        icon: Icon(LineIcons.question_circle),
      ),
    );
  }
}
