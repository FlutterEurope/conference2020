import 'dart:async';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';

class TutorialWrapper extends StatefulWidget {
  final Widget child;

  const TutorialWrapper({Key key, this.child}) : super(key: key);
  @override
  _TutorialWrapperState createState() => _TutorialWrapperState();
}

class _TutorialWrapperState extends State<TutorialWrapper> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{
          'show_how_to_toggle_layout',
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: widget.child,
    );
  }
}
