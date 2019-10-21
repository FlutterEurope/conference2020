import 'package:flutter/material.dart';

class SettingsToggle extends StatelessWidget {
  const SettingsToggle({
    Key key,
    this.title,
    this.onChanged,
    this.value,
  }) : super(key: key);

  final String title;
  final Function(bool) onChanged;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(child: Text(title)),
          Switch(
            onChanged: onChanged,
            value: value,
          ),
        ],
      ),
    );
  }
}
